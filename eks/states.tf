locals {
  backend_name = "${var.name}-${var.environment}-state"
}
terraform {
  backend "s3" {
    key    = "eks.tfstate"
    bucket = "${local.backend_name}-state"
  }
}
