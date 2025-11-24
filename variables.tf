variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
}

variable "environment" {
  description = "Name of the environment this resource is part of. Valid values include `dev`, `test`, `poc`, `prod`, `shared-services`"
  type        = string

  validation {
    condition     = contains(["dev", "test", "poc", "blueprint", "prod", "Shared-Services", "Root"], var.environment)
    error_message = "The value for \"environment\" must be one of the following: \"dev\"/\"test\"/\"poc\"/\"prod\"/\"shared-services\"/ (case-sensitive)"
  }
}

variable "account_name" {
  description = "A short name for the AWS account."
  type        = string
}

variable "aws_account" {
  description = "AWS account ID to assume the IAM role in"
  type        = string
}

variable "networking_account_id" {
  description = "The AWS Account ID of the central networking account where workload VPCs will be created."
  type        = string
}

variable "logging_account_id" {
  description = "The AWS Account ID of the central logging account where workload VPCs will be created."
  type        = string
}

variable "assume_role_name" {
  description = "ARN of an IAM Role to assume"
  type        = string
  default     = "TerraformExecutionRole"
}

variable "enable_flow_log" {
  description = "Whether or not to enable VPC Flow Logs"
  default     = false
  type        = bool
}

variable "s3_bucket_name" {
  description = "Central S3 for all network logs usch as vpc flow logs, aws network firewall logs and etc"
  type        = string
  default     = ""
}

# --- VPC CIDR Blocks ---
variable "inspection_vpc_cidr" {
  description = "The CIDR block for the Inspection VPC."
  type        = string
}

variable "egress_vpc_cidr" {
  description = "The CIDR block for the Egress VPC."
  type        = string
}

variable "ingress_vpc_cidr" {
  description = "The CIDR block for the Ingress VPC."
  type        = string
}

variable "endpoint_vpc_cidr" {
  description = "The CIDR block for the Endpoint VPC."
  type        = string
}

variable "firewall_tools_vpc_cidr" {
  description = "The CIDR block for the Firewall Tools VPC."
  type        = string
}

# --- Inspection VPC ---
variable "create_inspection" {
  description = "Whether to create the Inspection VPC."
  type        = bool
}

variable "inspection_vpc_name" {
  description = "The name for the Inspection VPC."
  type        = string
}

variable "public_subnets_cidr" {
  description = "List of public subnet CIDR blocks for the Inspection VPC."
  type        = list(string)
  default     = []
}

variable "private_subnets_cidr" {
  description = "List of private subnet CIDR blocks for the Inspection VPC."
  type        = list(string)
}

variable "tgw_subnets_cidr" {
  description = "List of TGW attachment subnet CIDR blocks for the Inspection VPC."
  type        = list(string)
}

variable "firewall_subnets_cidr" {
  description = "List of firewall endpoint subnet CIDR blocks for the Inspection VPC."
  type        = list(string)
}


# --- Egress VPC ---
variable "create_egress_vpc" {
  description = "Whether to create the Egress VPC."
  type        = bool
}

variable "egress_vpc_name" {
  description = "The name for the Egress VPC."
  type        = string
}

variable "egress_public_subnets_cidr" {
  description = "List of public subnet CIDR blocks for the Egress VPC."
  type        = list(string)
}

variable "egress_tgw_subnets_cidr" {
  description = "List of TGW attachment subnet CIDR blocks for the Egress VPC."
  type        = list(string)
}


# --- Ingress VPC ---
variable "create_ingress_vpc" {
  description = "Whether to create the Ingress VPC."
  type        = bool
}

variable "ingress_vpc_name" {
  description = "The name for the Ingress VPC."
  type        = string
}

variable "ingress_public_subnets_cidr" {
  description = "List of public subnet CIDR blocks for the Ingress VPC."
  type        = list(string)
}

variable "ingress_tgw_subnets_cidr" {
  description = "List of TGW attachment subnet CIDR blocks for the Ingress VPC."
  type        = list(string)
}


# --- Endpoint VPC ---
variable "create_endpoint_vpc" {
  description = "Whether to create the Endpoint VPC."
  type        = bool
}

variable "endpoint_vpc_name" {
  description = "The name for the Endpoint VPC."
  type        = string
}

variable "endpoint_public_subnets_cidr" {
  description = "List of public subnet CIDR blocks for the Endpoint VPC."
  type        = list(string)
}

variable "endpoint_tgw_subnets_cidr" {
  description = "List of TGW attachment subnet CIDR blocks for the Endpoint VPC."
  type        = list(string)
}


# --- Firewall Tools VPC ---
variable "create_firewall_tools_vpc" {
  description = "Whether to create the Firewall Tools VPC."
  type        = bool
}

variable "fw_tools_vpc_name" {
  description = "The name for the Firewall Tools VPC."
  type        = string
}

variable "firewall_tools_public_subnets_cidr" {
  description = "List of public subnet CIDR blocks for the Firewall Tools VPC."
  type        = list(string)
}

variable "firewall_tools_tgw_subnets_cidr" {
  description = "List of TGW attachment subnet CIDR blocks for the Firewall Tools VPC."
  type        = list(string)
}

variable "workload_vpcs" {
  description = "A map of objects defining the workload VPCs to create and share."
  type = map(object({
    name                   = string
    environment            = string # e.g., "dev", "prod"
    cidr                   = string
    public_subnets_cidr    = list(string)
    private_subnets_cidr   = list(string)
    tgw_subnets_cidr       = list(string)
    share_with_account_ids = list(string)
  }))
  default = {}
}

# --- TGW ---
variable "create_tgw" {
  description = "Whether to create the Transit Gateway."
  type        = bool
}

variable "tgw_asn" {
  description = "The BGP ASN for the Transit Gateway."
  type        = number
}


# --- Firewall ---
variable "firewall_type" {
  description = "The type of firewall to deploy: NETWORK_FIREWALL, GATEWAY_LOAD_BALANCER, or NONE."
  type        = string
}

variable "gwlb_name" {
  description = "The name for the Gateway Load Balancer."
  type        = string
}


# --- S2S VPN ---
variable "create_s2s_vpn" {
  description = "Whether to create the Site-to-Site VPN connection."
  type        = bool
}

variable "customer_gateway_ip" {
  description = "The public IP address of the customer's VPN gateway."
  type        = string
}

variable "customer_bgp_asn" {
  description = "The BGP ASN for the customer's gateway."
  type        = number
}


# --- Route 53 ---
variable "enable_hybrid_dns" {
  description = "Whether to enable Route 53 Hybrid DNS features."
  type        = bool
}

variable "on_prem_domain_name" {
  description = "The domain name for on-premise resources to be resolved by hybrid DNS."
  type        = string
}

variable "on_prem_dns_server_ip" {
  description = "The IP address of the on-premise DNS server."
  type        = string
}

