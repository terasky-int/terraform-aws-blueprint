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

variable "enable_flow_log" {
  description = "Whether or not to enable VPC Flow Logs"
  type        = bool
}

variable "s3_bucket_name" {
  description = "Central S3 for all network logs usch as vpc flow logs, aws network firewall logs and etc"
  type        = string
  default     = ""
}
