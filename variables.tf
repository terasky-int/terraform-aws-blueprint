################################################################################
# Global Variables
################################################################################
variable "aws_region" {
  description = "Name of the AWS region"
  type        = string
}

variable "aws_account" {
  description = "AWS account ID to assume the IAM role in"
  type        = string
}

variable "aws_account_log_archived" {
  description = "AWS account ID to assume the IAM role in"
  type        = string
  default     = ""
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
    condition     = contains(["dev", "blueprint", "test", "poc", "prod", "shared-services"], var.environment)
    error_message = "The value for \"environment\" must be one of the following: \"dev\"/\"test\"/\"poc\"/\"prod\"/\"shared-services\"/ (case-sensitive)"
  }
}

variable "account_name" {
  description = "The AWS account name"
  type        = string
}

variable "inspection_vpc_name" {
  description = "The Inspection VPC name"
  type        = string
  default     = "Inspection"
}

variable "create_inspection" {
  description = "Whether there is a Firewall in the environment"
  type        = bool
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

variable "ingress_vpc_name" { # Need to check the name of VPC and make default
  description = "The Ingress VPC name"
  type        = string
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
# AWS Inspection VPC Variables
################################################################################

variable "inspection_tgw_subnet_cidrs" {
  description = "A list of CIDRs for Transit Gateway Attachment subnets. Use the `tgw_subnet_network_start` variable to dynamically calculate the network CIDRs"
  type        = list(string)
  default     = []
}

variable "inspection_private_subnet_cidrs" {
  description = "A list of CIDRs for private subnets. Use the `private_subnet_network_start` variable to dynamically calculate the network CIDRs"
  type        = list(string)
  default     = []
}

variable "inspection_public_subnet_cidrs" {
  description = "A list of CIDRs for public subnets. Use the `public_subnet_network_start` variable to dynamically calculate the network CIDRs"
  type        = list(string)
  default     = []
}

variable "create_gwlb" {
  description = "Whether to create a AWS Gateway Load Balancer for the Firewall"
  type        = bool
}

variable "create_aws_fw" {
  description = "Whether to create a AWS Network Firewall"
  type        = bool
  default     = null
}

variable "gwlb_name" {
  description = "The name of the Gateway Load Balancer"
  type        = string
  default     = "GWLB"
}

################################################################################
# AWS Endpoint VPC Variables
################################################################################
variable "endpoint_vpc_name" {
  description = "The Endpoint VPC name"
  type        = string
  default     = "Endpoint"
}

variable "endpoint_tgw_subnet_cidrs" {
  description = "A list of CIDRs for Transit Gateway Attachment subnets. Use the `tgw_subnet_network_start` variable to dynamically calculate the network CIDRs"
  type        = list(string)
}

variable "endpoint_private_subnet_cidrs" {
  description = "A list of CIDRs for private subnets. Use the `private_subnet_network_start` variable to dynamically calculate the network CIDRs"
  type        = list(string)
}

#variable "inspection_vpc_is_inspection" {
#  description = "Whether this vpc contains a firewall or not. Should be true if the vpc contains a Firewall"
#  type        = bool
#}

#variable "endpoint_vpc_is_inspection" {
#  description = "Whether this vpc contains a firewall or not. Should be true if the vpc contains a Firewall"
#  type        = bool
#}

variable "enable_flow_log" {
  description = "Whether or not to enable VPC Flow Logs"
  type        = bool
}

variable "flow_log_destination_arn" {
  description = "The ARN of the the VPC Flow Logs S3 Bucket"
  type        = string
  default     = ""
}

################################################################################
# AWS Ingress VPC Variables
################################################################################

#variable "ingress_tgw_subnet_cidrs" {
#  description = "A list of CIDRs for Transit Gateway Attachment subnets. Use the `tgw_subnet_network_start` variable to dynamically calculate the network CIDRs"
#  type        = list(string)
#}

variable "ingress_private_subnet_cidrs" {
  description = "A list of CIDRs for private subnets. Use the `private_subnet_network_start` variable to dynamically calculate the network CIDRs"
  type        = list(string)
}

variable "ingress_public_subnet_cidrs" {
  description = "A list of CIDRs for public subnets. Use the `public_subnet_network_start` variable to dynamically calculate the network CIDRs"
  type        = list(string)
  default     = []
}

################################################################################
# AWS Egress VPC Variables
################################################################################
variable "egress_vpc_name" {
  description = "The Egress VPC name"
  type        = string
  default     = "Egress"
}

variable "egress_private_subnet_cidrs" {
  description = "A list of CIDRs for public subnets. Use the `public_subnet_network_start` variable to dynamically calculate the network CIDRs"
  type        = list(string)
  default     = []
}

variable "egress_public_subnet_cidrs" {
  description = "A list of CIDRs for public subnets. Use the `public_subnet_network_start` variable to dynamically calculate the network CIDRs"
  type        = list(string)
  default     = []
}

################################################################################
# AWS Firewall Tools VPC Variables
################################################################################
variable "create_fw_tools_vpc" {
  description = "Whether to create a VPC for Firewall Tools such as FortiGate Analyzer"
  type        = bool
}

variable "fw_tools_vpc_name" {
  description = "The FW Tools VPC name"
  type        = string
  default     = ""
}

variable "fw_tools_vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = ""
}

variable "fw_tools_tgw_subnet_cidrs" {
  description = "A list of CIDRs for Transit Gateway Attachment subnets. Use the `tgw_subnet_network_start` variable to dynamically calculate the network CIDRs"
  type        = list(string)
  default     = []
}

variable "fw_tools_private_subnet_cidrs" {
  description = "A list of CIDRs for private subnets. Use the `private_subnet_network_start` variable to dynamically calculate the network CIDRs"
  type        = list(string)
  default     = []
}

################################################################################
# AWS Network Firewall Variables
################################################################################
variable "anfw_name" {
  description = "Name for AWS Network Firewall"
  type        = string
  default     = "network-firewall"
}

variable "anfw_policy_name" {
  description = "The Policy Name for Network Firewall"
  type        = string
  default     = "Policy-test"
}
variable "firewall_subnet_cidrs" {
  description = "List of CIDRs for firewall subnets."
  type        = list(string)
  default     = []
}

# variable "cloudwatchlogs_environmnet" {
#   description = "Name of log group in CloudWatch"
#   type        = string
#   default     = ""
# }

# variable "s3_logs" {
#   type        = string
#   description = "Name of S3 logs"
#   default     = ""
# }

variable "s3_bucket_name" {
  description = "Central S3 for all network logs usch as vpc flow logs, aws network firewall logs and etc"
  type        = string
  default     = ""
}

# variable "s3_log_bucket_name" {
#   type    = string
#   default = ""
# }
variable "create_netwrok_firewall" {
  description = "This enable or deisable Network firewall: The default is false"
  type        = bool
  default     = null
}

variable "stateless_rule_group" {
  description = <<-EOF
  "Config for stateless rule group"
    stateless_rule_group = [
        {
        capacity    = 100
        name        = "stateless"
        description = "Stateless rule example1"
        rule_config = [{
            priority              = 1
            protocols_number      = [6]
            source_ipaddress      = "1.2.3.4/32"
            source_from_port      = 443
            source_to_port        = 443
            destination_ipaddress = "124.1.1.5/32"
            destination_from_port = 443
            destination_to_port   = 443
            tcp_flag = {
            flags = ["SYN"]
            masks = ["SYN", "ACK"]
            }
            actions = {
            type = "pass"
            }
        }]
        }]
        EOF
  type        = any
  default     = []
}

variable "fivetuple_stateful_rule_group" {
  description = <<-EOF
  "Config for 5-tuple type stateful rule group"
  fivetuple_stateful_rule_group = [
        {
        capacity    = 100
        name        = "stateful"
        description = "Stateful rule example1 with 5 tuple option"
        rule_config = [{
            description           = "Pass All Rule"
            protocol              = "TCP"
            source_ipaddress      = "1.2.3.4/32"
            source_port           = 443
            destination_ipaddress = "124.1.1.5/32"
            destination_port      = 443
            direction             = "any"
            sid                   = 1
            actions = {
            type = "pass"
            }
        }]
        },
    ]
  EOF
  type        = any
  default     = []
}

variable "suricata_stateful_rule_group" {
  description = <<-EOF
  "Config for Suricata type stateful rule group"
  suricata_stateful_rule_group = [
    {
        capacity    = 100
        name        = "SURICTASFEXAMPLE1"
        description = "Stateful rule example1 with suricta type"
        rules_file  = "./example.rules"
    }]
    EOF
  type        = any
  default     = []
}

variable "domain_stateful_rule_group" {
  description = <<-EOF
  "Config for domain type stateful rule group"
  domain_stateful_rule_group = [
    {
        capacity    = 100
        name        = "DOMAINSFEXAMPLE1"
        description = "Stateful rule example1 with domain list option"
        domain_list = ["test.example.com", "test1.example.com"]
        actions     = "DENYLIST"
        protocols   = ["HTTP_HOST", "TLS_SNI"]
        rule_variables = {
            ip_sets = [{
                key    = "WEBSERVERS_HOSTS"
                ip_set = ["10.0.0.0/16", "10.0.1.0/24", "192.168.0.0/16"]
            },
            {
                key    = "EXTERNAL_HOST"
                ip_set = ["0.0.0.0/0"]
            }]
            port_sets = [
            {
                key       = "HTTP_PORTS"
                port_sets = ["443", "80"]
            }]
        }
    }]
    EOF
  type        = any
  default     = []
}

################################################################################
# AWS TGW S2S Variables
################################################################################
variable "vpn_gateways" {
  description = <<-EOF
  "VPN Gateways for S2S, you can create multiple s2s endpoinds as you need with copy block for another s2s connection"
  Examples:
    # {
    #   tunnel1_preshared_key    = ""
    #   tunnel1_inside_cidr      = "169.254.94.252/30"
    #   tunnel2_preshared_key    = ""
    #   tunnel2_inside_cidr      = "169.254.93.168/30"
    #   bgp_asn                  = 64600
    #   destination_ip_address   = "1.1.1.1"
    #   cgw_name                 = "test1"
    #   private_destination_cidr = "10.200.0.0/16"
    #   s2s_routing              = true
    # },
    # {
    #   tunnel1_preshared_key    = ""
    #   tunnel1_inside_cidr      = "169.254.153.120/30"
    #   tunnel2_preshared_key    = ""
    #   tunnel2_inside_cidr      = "169.254.62.216/30"
    #   bgp_asn                  = 64601
    #   destination_ip_address   = "2.2.2.2"
    #   cgw_name                 = "test2"
    #   private_destination_cidr = "10.100.0.0/16"
    #   s2s_routing              = false
    # },

  EOF
  type        = any
  default     = []
}

variable "vpn_type" {
  description = "The type of connection"
  type        = string
  default     = "ipsec.1"
}

variable "create_aws_vpn_gateway" {
  description = "True if you want cretae VPN Gateway"
  type        = bool
  default     = null
}

variable "provided_preshared_key1" {
  description = "Provided preshared key for tunnel 1"
  type        = string
  default     = ""
}

variable "provided_preshared_key2" {
  description = "Provided preshared key for tunnel 2"
  type        = string
  default     = ""
}

################################################################################
# Route 53 Endpoints Variables
################################################################################
variable "create_central_dns" {
  description = "Whether to create central hybrid dns management"
  type        = bool
  default     = null
}

variable "inbound_endpoint_direction" {
  description = "(required) The direction of DNS queries to or from the Route 53 Resolver endpoint. Valid values are INBOUND (resolver forwards DNS queries to the DNS service for a VPC from your network or another VPC) or OUTBOUND (resolver forwards DNS queries from the DNS service for a VPC to your network or another VPC)."
  type        = string
  default     = "INBOUND"
}

variable "inbound_endpoint_name" {
  description = "(optional) The friendly name of the Route 53 Resolver endpoint."
  type        = string
  default     = "InboundEndpoint"
}

variable "outbound_endpoint_direction" {
  description = "(required) The direction of DNS queries to or from the Route 53 Resolver endpoint. Valid values are INBOUND (resolver forwards DNS queries to the DNS service for a VPC from your network or another VPC) or OUTBOUND (resolver forwards DNS queries from the DNS service for a VPC to your network or another VPC)."
  type        = string
  default     = "OUTBOUND"
}

variable "outbound_endpoint_name" {
  description = "(optional) The friendly name of the Route 53 Resolver endpoint."
  type        = string
  default     = "OutboundEndpoint"
}

################################################################################
# Route53 Private Zone Variables
################################################################################
variable "create_phz" {
  description = "Whether to create central PHZ"
  type        = bool
  default     = null
}

variable "private_zone_domain_name" {
  description = "The domain name of the hosted zone"
  type        = string
  default     = ""
}

variable "private_zone_comment" {
  description = "The description for the hosted zone. Defaults to 'Managed by Terraform'"
  type        = string
  default     = "Private domain on AWS for EC2 instance to resolve from custom network - Managed By Terraform"
}

variable "additional_vpc" {
  description = "A list of maps representing additional the VPCs to associate with the Route 53 zone"
  type = list(object({
    vpc_id     = string
    vpc_region = string
  }))
  default = []
}

################################################################################
# Route53 Resolver Rule Variables
################################################################################
variable "resolver_rules" {
  description = "A list of maps, where each map defines a resolver rule"
  type = list(object({
    resolver_rule_custom_domain_name = string
    resolver_rule_name               = string
    resolver_rule_type               = string
    target_ip                        = list(string)
  }))
  default = []
}

variable "allow_additional_cidr_blocks" {
  description = "Provide additional cidr blocks to allow in security groups"
  type        = list(string)
  default     = []
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

variable "private_vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
}

variable "private_vpc_name" {
  description = "The VPC name"
  type        = string
}

################################################################################
# Public Workload Variables
################################################################################
variable "public_subnet_tags" {
  description = "A map of tags to add to the public subnets"
  type        = map(string)
  default = {
    Tier                     = "public"
    "kubernetes.io/role/elb" = "1"
  }
}
variable "single_nat_gateway" {
  description = "value to determine if the VPC will have a single NAT Gateway or one per AZ"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Whether or not to enable NAT Gateways"
  type        = bool
  default     = true
}

variable "one_nat_gateway_per_az" {
  description = "Whether to create one NAT Gateway per AZ"
  type        = bool
  default     = false
}

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

variable "public_subnet_cidrs" {
  description = "A list of CIDRs for private subnets. Use the `private_subnet_network_start` variable to dynamically calculate the network CIDRs"
  type        = list(string)
  default     = []
}
