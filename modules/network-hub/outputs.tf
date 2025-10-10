# --- Inspection VPC Outputs ---
output "inspection_vpc_id" {
  description = "The ID of the Inspection VPC."
  value       = var.create_inspection ? module.inspection_vpc[0].vpc_id : null
}

output "inspection_firewall_subnets" {
  description = "List of Firewall/GWLB endpoint subnet IDs."
  value       = var.create_inspection ? module.inspection_vpc[0].intra_subnets : []
}

# --- Egress VPC Outputs ---
output "egress_vpc_id" {
  description = "The ID of the Egress VPC."
  value       = var.create_egress_vpc ? module.egress_vpc[0].vpc_id : null
}

output "egress_public_subnets" {
  description = "List of public subnet IDs in the Egress VPC."
  value       = var.create_egress_vpc ? module.egress_vpc[0].public_subnets : []
}

# --- Ingress VPC Outputs ---
output "ingress_vpc_id" {
  description = "The ID of the Ingress VPC."
  value       = var.create_ingress_vpc ? module.ingress_vpc[0].vpc_id : null
}

output "ingress_public_subnets" {
  description = "List of public subnet IDs in the Ingress VPC."
  value       = var.create_ingress_vpc ? module.ingress_vpc[0].public_subnets : []
}

# --- Endpoint VPC Outputs ---
output "endpoint_vpc_id" {
  description = "The ID of the Endpoint VPC."
  value       = var.create_endpoint_vpc ? module.endpoint_vpc[0].vpc_id : null
}

# FIX: Added missing output for endpoint public subnets
output "endpoint_public_subnets" {
  description = "List of public subnet IDs in the Endpoint VPC."
  value       = var.create_endpoint_vpc ? module.endpoint_vpc[0].public_subnets : []
}

# --- Firewall Tools VPC Outputs ---
output "firewall_tools_vpc_id" {
  description = "The ID of the Firewall Tools VPC."
  value       = var.create_firewall_tools_vpc ? module.firewall_tools_vpc[0].vpc_id : null
}

# FIX: Added missing output for firewall tools public subnets
output "firewall_tools_public_subnets" {
  description = "List of public subnet IDs in the Firewall Tools VPC."
  value       = var.create_firewall_tools_vpc ? module.firewall_tools_vpc[0].public_subnets : []
}


# --- TGW Outputs ---
output "tgw_id" {
  description = "The ID of the Transit Gateway."
  value       = var.create_tgw ? module.tgw[0].ec2_transit_gateway_id : null
}

output "inspection_tgw_vpc_attachment_id" {
  description = "The ID of the Inspection VPC TGW attachment."
  value       = var.create_tgw && var.create_inspection ? aws_ec2_transit_gateway_vpc_attachment.inspection[0].id : null
}

output "egress_tgw_vpc_attachment_id" {
  description = "The ID of the Egress VPC TGW attachment."
  value       = var.create_tgw && var.create_egress_vpc ? aws_ec2_transit_gateway_vpc_attachment.egress[0].id : null
}

output "ingress_tgw_vpc_attachment_id" {
  description = "The ID of the Ingress VPC TGW attachment."
  value       = var.create_tgw && var.create_ingress_vpc ? aws_ec2_transit_gateway_vpc_attachment.ingress[0].id : null
}

output "endpoint_tgw_vpc_attachment_id" {
  description = "The ID of the Endpoint VPC TGW attachment."
  value       = var.create_tgw && var.create_endpoint_vpc ? aws_ec2_transit_gateway_vpc_attachment.endpoint[0].id : null
}

output "firewall_tools_tgw_vpc_attachment_id" {
  description = "The ID of the Firewall Tools VPC TGW attachment."
  value       = var.create_tgw && var.create_firewall_tools_vpc ? aws_ec2_transit_gateway_vpc_attachment.firewall_tools[0].id : null
}

output "spoke_tgw_route_table_id" {
  description = "The ID of the Spoke TGW route table."
  value       = var.create_tgw ? aws_ec2_transit_gateway_route_table.spoke[0].id : null
}

output "inspection_tgw_route_table_id" {
  description = "The ID of the Inspection TGW route table."
  value       = var.create_tgw ? aws_ec2_transit_gateway_route_table.inspection[0].id : null
}


# --- Firewall Outputs ---
output "network_firewall_arn" {
  description = "The ARN of the AWS Network Firewall."
  value       = try(module.network_firewall[0].firewall_arn, null)
}

output "gwlb_arn" {
  description = "The ARN of the Gateway Load Balancer."
  value       = try(module.gwlb[0].lb_arn, null)
}

# --- S2S VPN Outputs ---
output "vpn_connection_id" {
  description = "The ID of the Site-to-Site VPN connection."
  value       = var.create_s2s_vpn ? aws_vpn_connection.main[0].id : null
}

# --- Route 53 Outputs ---
output "outbound_resolver_endpoint_id" {
  description = "The ID of the outbound Route 53 resolver endpoint."
  value       = var.enable_hybrid_dns && var.create_endpoint_vpc ? aws_route53_resolver_endpoint.outbound[0].id : null
}
