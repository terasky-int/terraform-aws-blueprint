################################################################################
# Global Variables
################################################################################
# AWS Variables
variable "account_name" {
  description = "The AWS account name"
  type        = string
}

variable "aws_region" {
  description = "Name of the AWS region"
  type        = string
}

variable "aws_account" {
  description = "AWS account ID to assume the IAM role in"
  type        = string
}

variable "assume_role_name" {
  description = "ARN of an IAM Role to assume"
  type        = string
  default     = "TerraformExecutionRole"
}

# Environment Variables
variable "environment" {
  description = "Name of the environment this resource is part of. Valid values include `dev`, `test`, `poc`, `prod`, `Shared-Services`"
  type        = string

  validation {
    condition     = contains(["dev", "test", "poc", "blueprint", "prod", "Shared-Services"], var.environment)
    error_message = "The value for \"environment\" must be one of the following: \"dev\"/\"test\"/\"poc\"/\"prod\"/\"shared-services\"/ (case-sensitive)"
  }
}

# VPC Flow Logs Variables
variable "enable_flow_log" {
  description = "Whether or not to enable VPC Flow Logs"
  type        = bool
}

variable "flow_log_destination_arn" {
  description = "The ARN of the the VPC Flow Logs S3 Bucket"
  type        = string
  default     = ""
}

# TGW Variables
variable "tgw_spoke_rt_id" {
  description = "The ID of the Spoke Route Table in the TGW, this is the RT that all the VPCs are attached to"
  type        = string
  default     = null
}

variable "tgw_hub_rt_id" {
  description = "The ID of the Hub Route Table in the TGW, this is the RT that only the Inspection VPC is attached to, we need to update the route there with the our new VPC"
  type        = string
  default     = null
}

variable "tgw_route_table_id" {
  description = "The ID of the TGW Route Table (in a single TGW RT deployment)"
  type        = string
  default     = null
}

# VPC CIDR Variables
variable "endpoint_vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = ""
}

variable "inspection_vpc_cidr" {
  description = "The CIDR block for the Inspection VPC in the Network account. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = ""
}

variable "ingress_vpc_cidr" {
  description = "The CIDR block for the Ingress VPC in the Network account"
  type        = string
  default     = ""
}

variable "egress_vpc_cidr" {
  description = "The CIDR block for the Egress VPC in the Network account"
  type        = string
  default     = ""
}

# Routing Variables
variable "create_inspection_routing" {
  description = "Whether there is a Custom Firewall (3th Party Vendor) in the environment"
  type        = bool
}

variable "create_gwlb_routing" {
  description = "Whether there is a AWS Gateway Load Balancer for the Custom Firewall in the environment"
  type        = bool
}

variable "create_ingress_routing" {
  description = "Whether the Workload VPC you created supposed to have routing from the internet"
  type        = bool
}

variable "create_egress_routing" {
  description = "True to update Egress VPC (Private and Public) RTs with the Workload VPC CIDR Block, in order to access the internet"
  type        = bool
}

################################################################################
# Private Workload Variables
################################################################################
variable "private_subnet_cidrs" {
  description = "A list of CIDRs for private subnets. Use the `private_subnet_network_start` variable to dynamically calculate the network CIDRs"
  type        = list(string)
}

variable "private_subnet_names" {
  description = "Explicit values to use in the Name tag on private subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "private"
}

variable "tgw_subnet_cidrs" {
  description = "A list of CIDRs for Transit Gateway Attachment subnets. Use the `tgw_subnet_network_start` variable to dynamically calculate the network CIDRs"
  type        = list(string)
  default     = []
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
}

variable "vpc_name" {
  description = "The VPC name"
  type        = string
}

################################################################################
# Public Workload Variables
################################################################################
# variable "create_public_workload" {
#   description = "Whether to create Public Workload"
#   type        = bool
# }

variable "public_vpc_cidr" {
  description = "The CIDR block for the Public VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = ""
}

variable "public_vpc_name" {
  description = "The Public VPC name"
  type        = string
  default     = ""
}

variable "public_vpc_private_subnet_cidrs" {
  description = "A list of CIDRs for private subnets. Use the `private_subnet_network_start` variable to dynamically calculate the network CIDRs"
  type        = list(string)
  default     = []
}

variable "public_vpc_private_subnet_names" {
  description = "Explicit values to use in the Name tag on private subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "public_vpc_public_subnet_cidrs" {
  description = "A list of CIDRs for private subnets. Use the `private_subnet_network_start` variable to dynamically calculate the network CIDRs"
  type        = list(string)
  default     = []
}

variable "public_vpc_public_subnet_names" {
  description = "Explicit values to use in the Name tag on private subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "public_vpc_tgw_subnet_cidrs" {
  description = "A list of CIDRs for Transit Gateway Attachment subnets. Use the `tgw_subnet_network_start` variable to dynamically calculate the network CIDRs"
  type        = list(string)
  default     = []
}

################################################################################
# Route 53 Variables
################################################################################
# variable "create_central_dns" {
#   description = "Whether to create central hybrid dns management"
#   type        = bool
# }

# variable "private_domain_name" {
#   description = "Provide private domain name that created on network account"
#   type        = string
#   default     = ""
# }

# variable "resolver_rule_id" {
#   description = "The resolver rule ID"
#   type        = string
#   default     = ""
# }

# variable "route53_phz_comment" {
#   description = "Provide description for Route 53 PHZ Domain"
#   type        = string
#   default     = ""
# }

# variable "route53_resolver_arn" {
#   description = "The Route 53 resolver ARN"
#   type        = string
#   default     = ""
# }
