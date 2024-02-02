# Create EKS cluster with terraform
## COnfi
## Export your AWS CLI Profile
```bash
export AWS_PROFILE={your-aws-profile-name}
```
## Edit env.json
```json
{
    "name" :"mgou-eks",
    "environment" : "testing",
    "region" : "ap-southeast-1",
    "availablity_zones" : ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"],
    "vpc_cidr" : "10.0.0.0/16",
    "private_subnets" : ["10.0.1.0/24","10.0.2.0/24"],
    "public_subnets" : ["10.0.101.0/24","10.0.102.0/24"],
    "enable_nat_gw" : true,
    "enable_vpn_gw" : false,
    "k8s_version" : "1.28",
    "node_group_min_size" : "1",
    "node_group_max_size" : "1",
    "node_group_desire_size" : "1",
    "node_group_capacity_type" : "ON_DEMAND",
    "node_instance_type" :"t2.medium",
    "node_disk_size": "80",
    "iam_admin_group_name" : "admin",
    "addon_tags" : {
        "tfmaintainer" : "mgou.dev",
        "github_repo" : "github.com/pyaephyohein/terraform-eks"
    }
    
}
```
## Create EKS Cluster

```bash
cd eks
terraform apply --var-file=../env.jcl
```
please note outputs. 
## Access EKS Cluster 
```bash
aws eks update-kubeconfig --region {your-region} --name {cluster_name}

## Copy context
kubectl config use-context {context_name}
```
