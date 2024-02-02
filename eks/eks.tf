module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name                   = "${var.name}-${var.environment}"
  cluster_version                = var.k8s_version
  cluster_endpoint_public_access = true
  create_cloudwatch_log_group    = false
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent    = true
      before_compute = true
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = flatten([module.vpc.public_subnets[*], module.vpc.private_subnets[*]])

  #EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types       = ["t2.medium", "t2.large"]
    disk_size            = var.node_disk_size
  }

  eks_managed_node_groups = {
    "${var.name}-${var.environment}" = {
      min_size       = var.node_group_min_size
      max_size       = var.node_group_max_size
      desired_size   = var.node_group_desire_size
      instance_types = ["${var.node_instance_type}"]
      capacity_type  = var.node_group_capacity_type
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = var.node_disk_size
            volume_type           = "gp3"
            iops                  = 16000
            throughput            = 1000
            encrypted             = true
            delete_on_termination = true
          }
        }
      }
    }
  }
  # create_aws_auth_configmap = false
  manage_aws_auth_configmap = true


  aws_auth_users = concat(
    [for users in data.aws_iam_group.admin_group.users : {
      userarn  = "${users.arn}"
      username = "${users.user_name}"
      groups   = ["system:masters"]
      }
    ]
  )



  tags = merge(local.default_tags)
}

data "aws_iam_group" "admin_group" {
  group_name = var.iam_admin_group_name
}

data "aws_eks_cluster_auth" "cluster" {
  name       = module.eks.cluster_name
}