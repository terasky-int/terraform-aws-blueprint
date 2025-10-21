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

variable "inspection_vpc_name" {
  description = "The specific name for the Inspection VPC."
  type        = string
}

variable "ingress_vpc_name" {
  description = "The specific name for the Ingress VPC."
  type        = string
}

variable "egress_vpc_name" {
  description = "The specific name for the Egress VPC."
  type        = string
}

variable "endpoint_vpc_name" {
  description = "The specific name for the Endpoint VPC."
  type        = string
}

variable "fw_tools_vpc_name" {
  description = "The specific name for the Firewall Tools VPC."
  type        = string
}

variable "gwlb_name" {
  description = "The specific name for the Gateway Load Balancer."
  type        = string
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

variable "create_inspection" {
  description = "Set to true to create the inspection VPC and related resources."
  type        = bool
}

variable "create_egress_vpc" {
  description = "Set to true to create the egress VPC."
  type        = bool
}

variable "create_ingress_vpc" {
  description = "Set to true to create the ingress VPC."
  type        = bool
}

variable "create_endpoint_vpc" {
  description = "Set to true to create the endpoint VPC."
  type        = bool
}

variable "create_firewall_tools_vpc" {
  description = "Set to true to create the Firewall Tools VPC."
  type        = bool
}

variable "public_subnets_cidr" {
  description = "A list of CIDR blocks for the inspection VPC's public subnets."
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "A list of CIDR blocks for the inspection VPC's private subnets."
  type        = list(string)
}

variable "tgw_subnets_cidr" {
  description = "A list of CIDR blocks for the inspection VPC's TGW attachment subnets."
  type        = list(string)
}

variable "firewall_subnets_cidr" {
  description = "A list of CIDR blocks for the firewall/GWLB endpoint subnets."
  type        = list(string)
}

variable "egress_public_subnets_cidr" {
  description = "A list of CIDR blocks for the egress VPC's public subnets (for NAT Gateways)."
  type        = list(string)
}

variable "egress_tgw_subnets_cidr" {
  description = "A list of CIDR blocks for the egress VPC's TGW attachment subnets."
  type        = list(string)
}

variable "ingress_public_subnets_cidr" {
  description = "A list of CIDR blocks for the ingress VPC's public subnets (for ALBs)."
  type        = list(string)
}

variable "ingress_tgw_subnets_cidr" {
  description = "A list of CIDR blocks for the ingress VPC's TGW attachment subnets."
  type        = list(string)
}

variable "endpoint_public_subnets_cidr" {
  description = "A list of CIDR blocks for the endpoint VPC's public subnets."
  type        = list(string)
}

variable "endpoint_tgw_subnets_cidr" {
  description = "A list of CIDR blocks for the endpoint VPC's TGW attachment subnets."
  type        = list(string)
}

variable "firewall_tools_public_subnets_cidr" {
  description = "A list of CIDR blocks for the Firewall Tools VPC's public subnets."
  type        = list(string)
}

variable "firewall_tools_tgw_subnets_cidr" {
  description = "A list of CIDR blocks for the Firewall Tools VPC's TGW attachment subnets."
  type        = list(string)
}

variable "create_tgw" {
  description = "Set to true to create the Transit Gateway."
  type        = bool
}

variable "tgw_asn" {
  description = "The BGP ASN for the Transit Gateway."
  type        = number
}

variable "firewall_type" {
  description = "The type of firewall to deploy. Valid values are 'NETWORK_FIREWALL', 'GATEWAY_LOAD_BALANCER', or 'NONE'."
  type        = string
  validation {
    condition     = contains(["NETWORK_FIREWALL", "GATEWAY_LOAD_BALANCER", "NONE"], var.firewall_type)
    error_message = "The firewall_type must be one of: NETWORK_FIREWALL, GATEWAY_LOAD_BALANCER, or NONE."
  }
}

variable "create_s2s_vpn" {
  description = "Set to true to create a Site-to-Site VPN connection to the TGW."
  type        = bool
  default     = false
}

variable "customer_gateway_ip" {
  description = "The public IP address of your on-premise customer gateway."
  type        = string
  default     = ""
}

variable "customer_bgp_asn" {
  description = "The BGP ASN for your customer gateway."
  type        = number
  default     = 65000
}

variable "enable_hybrid_dns" {
  description = "Set to true to enable Route 53 Hybrid DNS features."
  type        = bool
  default     = false
}

variable "on_prem_dns_server_ip" {
  description = "The IP address of the on-premise DNS server to forward queries to."
  type        = string
  default     = ""
}

variable "on_prem_domain_name" {
  description = "The domain name for which queries should be forwarded to the on-premise DNS server."
  type        = string
  default     = "corp.example.com"
}
