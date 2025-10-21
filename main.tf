module "network_hub" {
  source = "./modules/network-hub"

  # Explicitly pass the aliased "networking" provider to this module.
  providers = {
    aws = aws.networking
  }

  # General Settings
  aws_region       = var.aws_region
  environment      = var.environment
  account_name     = var.account_name
  assume_role_name = var.assume_role_name
  enable_flow_log  = var.enable_flow_log

  # VPC CIDR Blocks
  inspection_vpc_cidr     = var.inspection_vpc_cidr
  egress_vpc_cidr         = var.egress_vpc_cidr
  ingress_vpc_cidr        = var.ingress_vpc_cidr
  endpoint_vpc_cidr       = var.endpoint_vpc_cidr
  firewall_tools_vpc_cidr = var.firewall_tools_vpc_cidr

  # Inspection VPC Settings
  create_inspection     = var.create_inspection
  inspection_vpc_name   = var.inspection_vpc_name
  public_subnets_cidr   = var.public_subnets_cidr
  private_subnets_cidr  = var.private_subnets_cidr
  tgw_subnets_cidr      = var.tgw_subnets_cidr
  firewall_subnets_cidr = var.firewall_subnets_cidr

  # Egress VPC Settings
  create_egress_vpc          = var.create_egress_vpc
  egress_vpc_name            = var.egress_vpc_name
  egress_public_subnets_cidr = var.egress_public_subnets_cidr
  egress_tgw_subnets_cidr    = var.egress_tgw_subnets_cidr

  # Ingress VPC Settings
  create_ingress_vpc          = var.create_ingress_vpc
  ingress_vpc_name            = var.ingress_vpc_name
  ingress_public_subnets_cidr = var.ingress_public_subnets_cidr
  ingress_tgw_subnets_cidr    = var.ingress_tgw_subnets_cidr

  # Endpoint VPC Settings
  create_endpoint_vpc          = var.create_endpoint_vpc
  endpoint_vpc_name            = var.endpoint_vpc_name
  endpoint_public_subnets_cidr = var.endpoint_public_subnets_cidr
  endpoint_tgw_subnets_cidr    = var.endpoint_tgw_subnets_cidr

  # Firewall Tools VPC Settings
  create_firewall_tools_vpc          = var.create_firewall_tools_vpc
  fw_tools_vpc_name                  = var.fw_tools_vpc_name
  firewall_tools_public_subnets_cidr = var.firewall_tools_public_subnets_cidr
  firewall_tools_tgw_subnets_cidr    = var.firewall_tools_tgw_subnets_cidr

  # TGW Settings
  create_tgw = var.create_tgw
  tgw_asn    = var.tgw_asn

  # Firewall Settings
  firewall_type = var.firewall_type
  gwlb_name     = var.gwlb_name

  # S2S VPN Settings
  create_s2s_vpn      = var.create_s2s_vpn
  customer_gateway_ip = var.customer_gateway_ip
  customer_bgp_asn    = var.customer_bgp_asn

  # Route 53 Settings
  enable_hybrid_dns     = var.enable_hybrid_dns
  on_prem_domain_name   = var.on_prem_domain_name
  on_prem_dns_server_ip = var.on_prem_dns_server_ip
}

module "s3_logs_network_firewall" {
  source = "./modules/network-logs"

  providers = {
    aws = aws.logging
  }

  aws_region       = var.aws_region
  account_name     = "logging"
  assume_role_name = var.assume_role_name
  environment      = var.environment
  enable_flow_log  = var.enable_flow_log
  s3_bucket_name   = var.s3_bucket_name
}

module "network_workload" {
  source   = "./modules/network-workload"
  for_each = var.workload_vpcs

  # Explicitly pass the aliased "networking" provider to this module.
  providers = {
    aws = aws.networking
  }

  # General Settings
  environment     = each.value.environment
  account_name    = var.account_name # The "owner" account is still the hub
  enable_flow_log = var.enable_flow_log

  # VPC Settings from the map
  workload_vpc_name             = each.value.name
  workload_vpc_cidr             = each.value.cidr
  workload_public_subnets_cidr  = each.value.public_subnets_cidr
  workload_private_subnets_cidr = each.value.private_subnets_cidr
  workload_tgw_subnets_cidr     = each.value.tgw_subnets_cidr

  # TGW Attachment & VPC Sharing Settings
  tgw_id                   = var.create_tgw ? module.network_hub.tgw_id : null
  spoke_tgw_route_table_id = var.create_tgw ? module.network_hub.spoke_tgw_route_table_id : null
  share_with_account_ids   = each.value.share_with_account_ids
}
