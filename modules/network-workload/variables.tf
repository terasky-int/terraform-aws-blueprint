variable "aws_region" {
  description = "The AWS region to deploy the infrastructure in."
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., 'dev', 'prod')."
  type        = string
}

variable "account_name" {
  description = "A short name for the AWS account (e.g., 'networking', 'security')."
  type        = string
}

variable "assume_role_name" {
  description = "ARN of an IAM Role to assume"
  type        = string
  default     = "TerraformExecutionRole"
}

variable "workload_vpc_name" {
  description = "The specific name for the Workload VPC."
  type        = string
}

variable "workload_vpc_cidr" {
  description = "The CIDR block for the Workload VPC."
  type        = string
}

variable "workload_public_subnets_cidr" {
  description = "A list of CIDR blocks for the workload VPC's public subnets."
  type        = list(string)
}

variable "workload_private_subnets_cidr" {
  description = "A list of CIDR blocks for the workload VPC's private subnets."
  type        = list(string)
}

variable "workload_tgw_subnets_cidr" {
  description = "A list of CIDR blocks for the workload VPC's TGW attachment subnets."
  type        = list(string)
}

variable "tgw_id" {
  description = "The ID of the Transit Gateway to attach to."
  type        = string
}

variable "spoke_tgw_route_table_id" {
  description = "The ID of the TGW Spoke Route Table to associate the attachment with."
  type        = string
}
