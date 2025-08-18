################################################################################
# AWS TGW Outputs
################################################################################
output "tgw_id" {
  description = "The ID of the Transit Gateway"
  value       = module.tgw.id
}

output "tgw_arn" {
  description = "The ARN of the Transit Gateway"
  value       = module.tgw.arn
}

output "tgw_spoke_route_table_id" {
  description = "The ID of the Spoke Route Table"
  value       = module.tgw.tgw_spoke_route_table_id
}

output "tgw_spoke_route_table_arn" {
  description = "The ARN of the Spoke Route Table"
  value       = module.tgw.tgw_spoke_route_table_arn
}

output "tgw_hub_route_table_id" {
  description = "The ID of the Hub Route Table"
  value       = module.tgw.tgw_hub_route_table_id
}

output "tgw_hub_route_table_arn" {
  description = "The ARN of the Hub Route Table"
  value       = module.tgw.tgw_hub_route_table_arn
}

output "tgw_route_table_id" {
  description = "The ID of the TGW Route Table (in a single TGW RT deployment)"
  value       = module.tgw.tgw_route_table_id
}

# output "tgw_ram_resource_share_id" {
#   description = "The ID of the TGW RAM share"
#   value       = module.tgw.tgw_ram_resource_share_id
# }

# output "tgw_ram_resource_share_arn" {
#   description = "The ARN of the TGW RAM share"
#   value       = module.tgw.tgw_ram_resource_share_arn
# }

################################################################################
# AWS Inspection VPC Outputs
################################################################################
output "inspection_vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.inspection_vpc[*].vpc_arn
}

output "inspection_vpc_id" {
  description = "The ID of the VPC"
  value       = module.inspection_vpc[*].vpc_id
}

output "inspection_private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.inspection_vpc[*].private_subnets
}

output "inspection_public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.inspection_vpc[*].public_subnets
}

output "inspection_database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.inspection_vpc[*].database_subnets
}

output "inspection_tgw_subnets" {
  description = "List of IDs of Transit Gateway Attachment subnets"
  value       = module.inspection_vpc[*].tgw_subnets
}

################################################################################
# AWS Endpoint VPC Outputs
################################################################################
output "endpoint_vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.endpoint_vpc.vpc_arn
}

output "endpoint_vpc_id" {
  description = "The ID of the VPC"
  value       = module.endpoint_vpc.vpc_id
}

output "endpoint_tgw_subnets" {
  description = "List of IDs of Transit Gateway Attachment subnets"
  value       = module.endpoint_vpc.tgw_subnets
}

output "endpoint_private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.endpoint_vpc.private_subnets
}

#output "endpoint_public_subnets" {
#  description = "List of IDs of public subnets"
#  value       = module.endpoint_vpc.public_subnets
#}

#output "endpoint_database_subnets" {
#  description = "List of IDs of database subnets"
#  value       = module.endpoint_vpc.database_subnets
#}

# output "gwlb_id" {
#   description = "The ID of the Gateway Load Balancer"
#   value       = module.gwlb[*].gwlb_id
# }

# output "gwlb_arn" {
#   description = "The ID of the Gateway Load Balancer"
#   value       = module.gwlb[*].gwlb_arn
# }

# output "gwlb_vpc_endpoint_service_id" {
#   description = "The ID of the Gateway Load Balancer VPC Endpoint Service"
#   value       = module.gwlb[*].gwlb_vpc_endpoint_service_id
# }

# output "gwlb_vpc_endpoint_service_arn" {
#   description = "The ARN of the Gateway Load Balancer VPC Endpoint Service"
#   value       = module.gwlb[*].gwlb_vpc_endpoint_service_arn
# }

# output "gwlb_vpc_endpoint_service_name" {
#   description = "The Name of the Gateway Load Balancer VPC Endpoint Service"
#   value       = module.gwlb[*].gwlb_vpc_endpoint_service_name
# }

# output "gwlb_vpc_endpoint_ids" {
#   description = "List of IDs of the GWLB VPC Endpoint"
#   value       = module.gwlb[*].gwlb_vpc_endpoint_ids
# }

# output "gwlb_vpc_endpoint_arns" {
#   description = "List of ARNs of the GWLB VPC Endpoint"
#   value       = module.gwlb[*].gwlb_vpc_endpoint_arns
# }

################################################################################
# AWS Egress VPC Outputs
################################################################################

output "egress_vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.egress_vpc[*].vpc_arn
}

output "egress_vpc_id" {
  description = "The ID of the VPC"
  value       = module.egress_vpc[*].vpc_id
}

output "egress_private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.egress_vpc[*].private_subnets
}

output "egress_public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.egress_vpc[*].public_subnets
}

################################################################################
# AWS FireWall Tools VPC Outputs
################################################################################
output "fw_tools_vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.fw_tools_vpc[*].vpc_arn
}

output "fw_tools_vpc_id" {
  description = "The ID of the VPC"
  value       = module.fw_tools_vpc[*].vpc_id
}

output "fw_tools_vpc_tgw_subnets" {
  description = "List of IDs of Transit Gateway Attachment subnets"
  value       = module.fw_tools_vpc[*].tgw_subnets
}

output "fw_tools_vpc_private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.fw_tools_vpc[*].private_subnets
}

################################################################################
# AWS Network FireWall Outputs
################################################################################
# output "aws_firewall_id" {
#   description = "The ID of AWS Netwrok Firewall"
#   value       = try(module.network_firewall[*].id, null)
# }

# output "firewall_endpoint_ids" {
#   description = "ListIDs of firewall endppoinds"
#   value       = try(module.network_firewall[*].endpoint_ids, null)
# }

# output "aws_firewall_arn" {
#   description = "ARN of Network Firewall"
#   value       = try(module.network_firewall[*].arn, null)
# }

################################################################################
# AWS VPN S2S Outputs
################################################################################
# output "preshared_key1" {
#   description = "Provided tunnel preshared key 1"
#   value       = try(module.vpn[0].tunnel1_preshared_key, null)
#   sensitive   = true
# }

# output "preshared_key2" {
#   description = "Provided tunnel preshared key 2"
#   value       = try(module.vpn[0].tunnel2_preshared_key, null)
#   sensitive   = true
# }

# output "generated_tunnel1_presharedkey1" {
#   description = "Generated password for tunnel preshared key 1"
#   value       = try(module.vpn[*].generated_tunnel1_presharedkey1, null)
#   sensitive   = true
# }

# output "generated_tunnel2_presharedkey2" {
#   description = "Generated password for tunnel preshared key 2"
#   value       = try(module.vpn[*].generated_tunnel2_presharedkey2, null)
#   sensitive   = true
# }

output "s3_log_archived_arn" {
  description = "The ARN of centralized S3 bucket logs"
  value       = try(module.s3_logs_network_firewall[0].s3_bucket_arn, null)
}

# ################################################################################
# # Route 53 Outputs
# ################################################################################
# # Inbound Endpoint
# output "route53_inbound_endpoint_id" {
#   description = "The ARN of the Route 53 Resolver endpoint."
#   value       = try(module.hybrid_private_dns[0].route53_inbound_endpoint_id, null)
# }

# output "route53_inbound_endpoint_ip_addresses" {
#   description = "IP addresses in your VPC that you want DNS queries to pass through on the way from your VPCs to your network (for outbound endpoints) or on the way from your network to your VPCs (for inbound endpoints)"
#   value       = try(module.hybrid_private_dns[0].route53_inbound_endpoint_ip_addresses, null)
# }

# # Outbound Endpoint
# output "route53_outbound_endpoint_id" {
#   description = "The ARN of the Route 53 Resolver endpoint."
#   value       = try(module.hybrid_private_dns[0].route53_outbound_endpoint_id, null)
# }

# output "route53_outbound_endpoint_ip_addresses" {
#   description = "IP addresses in your VPC that you want DNS queries to pass through on the way from your VPCs to your network (for outbound endpoints) or on the way from your network to your VPCs (for inbound endpoints)"
#   value       = try(module.hybrid_private_dns[0].route53_outbound_endpoint_ip_addresses, null)
# }

# ################################################################################
# # Route53 Resolver Rule Outputs
# ################################################################################
# output "route53_resolver_rule_arn" {
#   description = "The ARN of Route53 Resolver Rules that have created"
#   value       = try(module.hybrid_private_dns[0].resolver_rule_arn, null)
# }

# output "resolver_rule_id" {
#   description = "The ID of Route 53 Resolver Rules"
#   value       = try(module.hybrid_private_dns[0].resolver_rule_id, null)
# }
