variable "aws_region" {
  description = "Name of the AWS region"
  type        = string
}

variable "assume_role_name" {
  description = "ARN of an IAM Role to assume"
  type        = string
  default     = "TerraformExecutionRole"
}

variable "environment" {
  description = "Name of the environment this resource is part of. Valid values include `dev`, `test`, `poc`, `prod`, `shared-services`"
  type        = string

  validation {
    condition     = contains(["dev", "test", "poc", "prod", "blueprint", "shared-services"], var.environment)
    error_message = "The value for \"environment\" must be one of the following: \"dev\"/\"test\"/\"poc\"/\"prod\"/\"shared-services\"/ (case-sensitive)"
  }
}

variable "destination_account" {
  description = "AWS account ID to share the networking resource with"
  type        = string
}

variable "network_account" {
  description = "AWS account ID to share the networking resource with"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR Block of the VPC to share"
  type        = string
  default     = null
}

variable "public_workload" {
  description = "Whether the VPC has public subnets and Internet Gateway"
  type        = bool
  #  default     = null
}

variable "route53_resolver_arn" {
  description = "Provide ARN of Route 53 Resolver Rule to share"
  type        = string
  default     = ""
}
