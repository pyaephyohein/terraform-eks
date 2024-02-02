variable "name" {
  type = string
}
variable "region" {
  type = string
}
variable "environment" {
  type = string
}
variable "availablity_zones" {
  type = list(string)
}
variable "vpc_cidr" {
  type = string
}
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "enable_nat_gw" {
  type = bool
}
variable "enable_vpn_gw" {
  type = bool
}
variable "addon_tags" {
  type = map(string)
}
variable "k8s_version" {
  type = string
}
variable "node_group_min_size" {
  type = string
}
variable "node_group_max_size" {
  type = string
}
variable "node_group_desire_size" {
  type = string
}
variable "node_group_capacity_type" {
  type = string
}
variable "node_instance_type" {
  type = string
}
variable "node_disk_size" {
  type = string
}
variable "iam_admin_group_name" {
  type = string
}