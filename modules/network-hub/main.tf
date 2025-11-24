# Data source to get the list of available Availability Zones (AZs) in the specified region.
# This makes the configuration dynamic and avoids hardcoding AZ names.
data "aws_availability_zones" "available" {
  state = "available"
}

# --------------------------------------------------------------------------------------------------
# Transit Gateway (TGW) Module
# --------------------------------------------------------------------------------------------------
module "tgw" {
  count   = var.create_tgw ? 1 : 0
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "~> 3.0" #

  name            = "${var.environment}-${var.account_name}-TGW"
  amazon_side_asn = var.tgw_asn

  enable_auto_accept_shared_attachments = true

  tags = {
    Terraform   = "true"
    Environment = "hub"
  }
}

# --------------------------------------------------------------------------------------------------
# VPC Modules (Inspection, Egress, Ingress, Endpoint, Firewall Tools)
# --------------------------------------------------------------------------------------------------
module "inspection_vpc" {
  count   = var.create_inspection ? 1 : 0
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0" # 

  name = "${var.environment}-${var.account_name}-${var.inspection_vpc_name}-VPC"
  cidr = var.inspection_vpc_cidr

  # azs              = slice(data.aws_availability_zones.available.names, 0, length(var.public_subnets_cidr))
  azs              = data.aws_availability_zones.available.names
  private_subnets  = var.private_subnets_cidr
  public_subnets   = var.public_subnets_cidr
  database_subnets = var.tgw_subnets_cidr
  intra_subnets    = var.firewall_subnets_cidr # Using intra_subnets for firewall endpoints

  enable_nat_gateway = true
  # FIX: Set to false to create per-AZ route tables for the TGW subnets, enabling correct routing.
  single_nat_gateway   = false
  enable_dns_hostnames = true

  tags                 = { Terraform = "true", Environment = "inspection" }
  database_subnet_tags = { Name = "tgw-subnet" }
  intra_subnet_tags    = { Name = "firewall-subnet" }

  enable_flow_log = var.enable_flow_log
}

module "egress_vpc" {
  count   = var.create_egress_vpc ? 1 : 0
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0" # 

  name = "${var.environment}-${var.account_name}-${var.egress_vpc_name}-VPC"
  cidr = var.egress_vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, length(var.egress_public_subnets_cidr))
  public_subnets  = var.egress_public_subnets_cidr
  private_subnets = var.egress_tgw_subnets_cidr # Using private subnets for TGW attachments

  enable_nat_gateway     = true # Egress VPC needs NAT for outbound traffic
  one_nat_gateway_per_az = true # Recommended for production egress
  enable_dns_hostnames   = true

  tags                = { Terraform = "true", Environment = "egress" }
  private_subnet_tags = { Name = "tgw-subnet" }

  enable_flow_log = var.enable_flow_log
}

module "ingress_vpc" {
  count   = var.create_ingress_vpc ? 1 : 0
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0" # 

  name = "${var.environment}-${var.account_name}-${var.ingress_vpc_name}-VPC"
  cidr = var.ingress_vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, length(var.ingress_public_subnets_cidr))
  public_subnets  = var.ingress_public_subnets_cidr
  private_subnets = var.ingress_tgw_subnets_cidr # Using private subnets for TGW attachments

  enable_dns_hostnames = true

  tags                = { Terraform = "true", Environment = "ingress" }
  private_subnet_tags = { Name = "tgw-subnet" }

  enable_flow_log = var.enable_flow_log
}

module "endpoint_vpc" {
  count   = var.create_endpoint_vpc ? 1 : 0
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0" # 

  name = "${var.environment}-${var.account_name}-${var.endpoint_vpc_name}-VPC"
  cidr = var.endpoint_vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, length(var.endpoint_public_subnets_cidr))
  public_subnets  = var.endpoint_public_subnets_cidr
  private_subnets = var.endpoint_tgw_subnets_cidr # Using private subnets for TGW attachments

  enable_dns_hostnames = true

  tags                = { Terraform = "true", Environment = "endpoint" }
  private_subnet_tags = { Name = "tgw-subnet" }

  enable_flow_log = var.enable_flow_log
}

module "firewall_tools_vpc" {
  count   = var.create_firewall_tools_vpc ? 1 : 0
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0" # 

  name = "${var.environment}-${var.account_name}-${var.fw_tools_vpc_name}-VPC"
  cidr = var.firewall_tools_vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, length(var.firewall_tools_public_subnets_cidr))
  public_subnets  = var.firewall_tools_public_subnets_cidr
  private_subnets = var.firewall_tools_tgw_subnets_cidr # Using private subnets for TGW attachments

  enable_dns_hostnames = true

  tags                = { Terraform = "true", Environment = "firewall-tools" }
  private_subnet_tags = { Name = "tgw-subnet" }

  enable_flow_log = var.enable_flow_log
}


# --------------------------------------------------------------------------------------------------
# Firewall Section
# --------------------------------------------------------------------------------------------------
locals {
  # Create a map of AZ to subnet ID for the Network Firewall subnet mapping.
  # The module requires a map of objects, so we construct it with a for-loop.
  inspection_subnet_mapping = var.create_inspection ? {
    for i, subnet_id in module.inspection_vpc[0].intra_subnets :
    slice(module.inspection_vpc[0].azs, 0, length(module.inspection_vpc[0].intra_subnets))[i] => { subnet_id = subnet_id }
  } : {}
}

module "network_firewall" {
  source  = "terraform-aws-modules/network-firewall/aws"
  version = "~> 2.0"
  count   = var.firewall_type == "NETWORK_FIREWALL" ? 1 : 0

  name           = "${var.environment}-${var.account_name}-anf"
  description    = "AWS Network Firewall"
  vpc_id         = module.inspection_vpc[0].vpc_id
  subnet_mapping = local.inspection_subnet_mapping

  # Inline policy definition for module v2.0
  policy_stateless_default_actions          = ["aws:pass"]
  policy_stateless_fragment_default_actions = ["aws:pass"]

  tags = {
    Name = "${var.environment}-${var.account_name}-anf"
  }
}

# --------------------------------------------------------------------------------------------------
# Gateway Load Balancer
# --------------------------------------------------------------------------------------------------
module "gwlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"
  count   = var.firewall_type == "GATEWAY_LOAD_BALANCER" ? 1 : 0

  name               = "${var.environment}-${var.account_name}-${var.gwlb_name}-GWLB"
  load_balancer_type = "gateway"
  vpc_id             = module.inspection_vpc[0].vpc_id
  subnets            = module.inspection_vpc[0].intra_subnets

  tags = {
    Name = "${var.environment}-${var.account_name}-${var.gwlb_name}-GWLB"
  }
}

resource "aws_vpc_endpoint" "gwlb" {
  count = var.firewall_type == "GATEWAY_LOAD_BALANCER" ? 1 : 0

  vpc_id            = module.inspection_vpc[0].vpc_id
  service_name      = module.gwlb[0].id
  subnet_ids        = module.inspection_vpc[0].intra_subnets
  vpc_endpoint_type = "GatewayLoadBalancer"
  tags              = { Name = "gwlb-endpoint" }
}

# --------------------------------------------------------------------------------------------------
# TGW Route Tables
# --------------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "spoke" {
  count              = var.create_tgw ? 1 : 0
  transit_gateway_id = module.tgw[0].ec2_transit_gateway_id
  tags               = { Name = "spoke-tgw-rt" }
}

resource "aws_ec2_transit_gateway_route_table" "inspection" {
  count              = var.create_tgw ? 1 : 0
  transit_gateway_id = module.tgw[0].ec2_transit_gateway_id
  tags               = { Name = "inspection-tgw-rt" }
}

# --------------------------------------------------------------------------------------------------
# TGW VPC Attachments & Associations
# --------------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "inspection" {
  count      = var.create_tgw && var.create_inspection ? 1 : 0
  vpc_id     = module.inspection_vpc[0].vpc_id
  subnet_ids = module.inspection_vpc[0].database_subnets

  transit_gateway_id                              = module.tgw[0].ec2_transit_gateway_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags                                            = { Name = "inspection-vpc-attachment" }
}

resource "aws_ec2_transit_gateway_route_table_association" "inspection" {
  count                          = var.create_tgw && var.create_inspection ? 1 : 0
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.inspection[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.inspection[0].id

  depends_on = [ aws_ec2_transit_gateway_vpc_attachment.inspection ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "egress" {
  count      = var.create_tgw && var.create_egress_vpc ? 1 : 0
  vpc_id     = module.egress_vpc[0].vpc_id
  subnet_ids = module.egress_vpc[0].private_subnets

  transit_gateway_id                              = module.tgw[0].ec2_transit_gateway_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags                                            = { Name = "egress-vpc-attachment" }
}

resource "aws_ec2_transit_gateway_route_table_association" "egress" {
  count                          = var.create_tgw && var.create_egress_vpc ? 1 : 0
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.egress[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke[0].id # Associate with spoke RT to receive traffic

  depends_on = [ aws_ec2_transit_gateway_vpc_attachment.egress ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "ingress" {
  count      = var.create_tgw && var.create_ingress_vpc ? 1 : 0
  vpc_id     = module.ingress_vpc[0].vpc_id
  subnet_ids = module.ingress_vpc[0].private_subnets

  transit_gateway_id                              = module.tgw[0].ec2_transit_gateway_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags                                            = { Name = "ingress-vpc-attachment" }
}

resource "aws_ec2_transit_gateway_route_table_association" "ingress" {
  count                          = var.create_tgw && var.create_ingress_vpc ? 1 : 0
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.ingress[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke[0].id # Also associate with spoke RT

  depends_on = [ aws_ec2_transit_gateway_vpc_attachment.ingress ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "endpoint" {
  count      = var.create_tgw && var.create_endpoint_vpc ? 1 : 0
  vpc_id     = module.endpoint_vpc[0].vpc_id
  subnet_ids = module.endpoint_vpc[0].private_subnets

  transit_gateway_id                              = module.tgw[0].ec2_transit_gateway_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags                                            = { Name = "endpoint-vpc-attachment" }
}

resource "aws_ec2_transit_gateway_route_table_association" "endpoint" {
  count                          = var.create_tgw && var.create_endpoint_vpc ? 1 : 0
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.endpoint[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke[0].id # Also associate with spoke RT

  depends_on = [ aws_ec2_transit_gateway_vpc_attachment.endpoint ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "firewall_tools" {
  count      = var.create_tgw && var.create_firewall_tools_vpc ? 1 : 0
  vpc_id     = module.firewall_tools_vpc[0].vpc_id
  subnet_ids = module.firewall_tools_vpc[0].private_subnets

  transit_gateway_id                              = module.tgw[0].ec2_transit_gateway_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags                                            = { Name = "firewall-tools-vpc-attachment" }
}

resource "aws_ec2_transit_gateway_route_table_association" "firewall_tools" {
  count                          = var.create_tgw && var.create_firewall_tools_vpc ? 1 : 0
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.firewall_tools[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke[0].id # Also associate with spoke RT

  depends_on = [ aws_ec2_transit_gateway_vpc_attachment.firewall_tools ]
}


# --------------------------------------------------------------------------------------------------
# TGW Static Routing
# --------------------------------------------------------------------------------------------------
# Spoke VPCs send all traffic to the Inspection VPC for firewalling.
resource "aws_ec2_transit_gateway_route" "spoke_to_inspection" {
  count                          = var.create_tgw && var.create_inspection ? 1 : 0
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke[0].id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.inspection[0].id
}

# After inspection, send internet-bound traffic to the Egress VPC.
resource "aws_ec2_transit_gateway_route" "inspection_to_egress" {
  count                          = var.create_tgw && var.create_inspection && var.create_egress_vpc ? 1 : 0
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.inspection[0].id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.egress[0].id
}

# --------------------------------------------------------------------------------------------------
# VPC Route Table Configuration for Firewall Traffic Steering
# --------------------------------------------------------------------------------------------------
data "aws_network_interface" "gwlb_enis" {
  for_each = var.firewall_type == "GATEWAY_LOAD_BALANCER" && var.create_inspection ? toset(aws_vpc_endpoint.gwlb[0].network_interface_ids) : toset([])
  id       = each.key
}

locals {
  # Create a map of AZ -> GWLB ENI ID for routing
  gwlb_eni_map = {
    for eni in data.aws_network_interface.gwlb_enis : eni.availability_zone => eni.id
  }

  # Create a map of AZ -> Network Firewall Endpoint ID by parsing the module's firewall_status output
  network_firewall_endpoint_map = var.firewall_type == "NETWORK_FIREWALL" && var.create_inspection ? {
    for az, state in module.network_firewall[0].status.sync_states : az => state.attachment.endpoint_id if state.attachment != null
  } : {}

  firewall_endpoints = var.firewall_type == "NETWORK_FIREWALL" ? (
    var.create_inspection ? local.network_firewall_endpoint_map : {}
    ) : (
    var.firewall_type == "GATEWAY_LOAD_BALANCER" ? (
      var.create_inspection ? local.gwlb_eni_map : {}
    ) : {}
  )
}

# In Inspection VPC: TGW subnets route all traffic to the firewall endpoints.
resource "aws_route" "tgw_to_firewall" {
  count = var.create_inspection && var.firewall_type != "NONE" ? length(module.inspection_vpc[0].database_subnets) : 0

  route_table_id         = module.inspection_vpc[0].database_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"

  # Route to the correct endpoint type based on the firewall choice
  # FIX: Changed to use the module's `azs` output, which is the correct attribute for VPC module v5.0
  vpc_endpoint_id = var.firewall_type == "NETWORK_FIREWALL" ? (
    lookup(local.firewall_endpoints, module.inspection_vpc[0].azs[count.index], null)
    ) : null
  network_interface_id = var.firewall_type == "GATEWAY_LOAD_BALANCER" ? (
    lookup(local.firewall_endpoints, module.inspection_vpc[0].azs[count.index], null)
    ) : null
}


# In Inspection VPC: Firewall subnets route all traffic back to the TGW.
resource "aws_route" "firewall_to_tgw" {
  count = var.create_inspection && var.firewall_type != "NONE" ? length(module.inspection_vpc[0].intra_route_table_ids) : 0

  route_table_id         = module.inspection_vpc[0].intra_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.create_tgw ? module.tgw[0].ec2_transit_gateway_id : null

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.inspection
  ]
}

# --------------------------------------------------------------------------------------------------
# AWS Site-to-Site VPN Connection
# --------------------------------------------------------------------------------------------------
resource "aws_customer_gateway" "main" {
  count      = var.create_s2s_vpn ? 1 : 0
  bgp_asn    = var.customer_bgp_asn
  ip_address = var.customer_gateway_ip
  type       = "ipsec.1"

  tags = {
    Name = "on-premise-cgw"
  }
}

resource "aws_vpn_connection" "main" {
  count                   = var.create_s2s_vpn ? 1 : 0
  customer_gateway_id     = aws_customer_gateway.main[0].id
  transit_gateway_id      = module.tgw[0].ec2_transit_gateway_id
  type                    = "ipsec.1"
  static_routes_only      = false
  enable_acceleration     = false
  local_ipv4_network_cidr = "0.0.0.0/0"

  tags = {
    Name = "vpn-to-on-premise"
  }
}

# --------------------------------------------------------------------------------------------------
# Route 53 Hybrid DNS Management
# --------------------------------------------------------------------------------------------------
module "route53_resolver_sg" {
  count   = var.enable_hybrid_dns && var.create_endpoint_vpc ? 1 : 0
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "route53-resolver-sg"
  description = "Allow DNS queries from within the VPC"
  vpc_id      = module.endpoint_vpc[0].vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 53
      to_port     = 53
      protocol    = "tcp"
      description = "Allow inbound TCP DNS queries"
      cidr_blocks = module.endpoint_vpc[0].vpc_cidr_block
    },
    {
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      description = "Allow inbound UDP DNS queries"
      cidr_blocks = module.endpoint_vpc[0].vpc_cidr_block
    },
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = { Environment = "endpoint" }
}

resource "aws_route53_resolver_endpoint" "outbound" {
  count     = var.enable_hybrid_dns && var.create_endpoint_vpc ? 1 : 0
  name      = "outbound-resolver"
  direction = "OUTBOUND"
  security_group_ids = [
    module.route53_resolver_sg[0].security_group_id
  ]

  ip_address {
    subnet_id = module.endpoint_vpc[0].private_subnets[0]
  }

  ip_address {
    subnet_id = module.endpoint_vpc[0].private_subnets[1]
  }

  tags = { Environment = "endpoint" }
}

resource "aws_route53_resolver_rule" "forward_to_on_prem" {
  count              = var.enable_hybrid_dns && var.create_endpoint_vpc ? 1 : 0
  domain_name        = var.on_prem_domain_name
  name               = "forward-to-on-prem"
  rule_type          = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound[0].id

  target_ip {
    ip = var.on_prem_dns_server_ip
  }

  tags = { Environment = "endpoint" }
}

resource "aws_route53_resolver_rule_association" "on_prem_forward" {
  count            = var.enable_hybrid_dns && var.create_endpoint_vpc ? 1 : 0
  resolver_rule_id = aws_route53_resolver_rule.forward_to_on_prem[0].id
  vpc_id           = module.endpoint_vpc[0].vpc_id
}
