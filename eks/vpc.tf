locals {
  dynamic_tags = {
    Environment = var.environment
    Terraform = "true"
  }
  default_tags = merge(local.dynamic_tags, var.addon_tags)
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = "${var.name}-${var.environment}"
  cidr = var.vpc_cidr

  azs             = var.availablity_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  # default_security_group_name = "${var.name}-${var.environment}"
  enable_nat_gateway = var.enable_nat_gw
  enable_vpn_gateway = var.enable_nat_gw

  tags = merge(local.default_tags , {"kubernetes.io/cluster/${var.name}-${var.environment}" = "shared"})
}


