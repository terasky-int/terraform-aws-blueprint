################################################################################
# Locals
################################################################################

locals {
  vpc_name = "${var.environment}-${var.account_name}-${var.vpc_name}-VPC"
}

################################################################################
# VPC
################################################################################
module "workload_private" {
  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-vpc"

  vpc_name = local.vpc_name
  vpc_cidr = var.vpc_cidr

  tgw_subnet_cidrs     = var.tgw_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  private_subnet_names = var.private_subnet_names

  enable_flow_log          = var.enable_flow_log
  flow_log_destination_arn = "${var.flow_log_destination_arn}/${local.vpc_name}/"

}

# TGW Attachment to Private VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc" {
  subnet_ids         = module.workload_private.tgw_subnets
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
  vpc_id             = module.workload_private.vpc_id

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = {
    Name = format("%s-TGW-Attachment", module.workload_private.name)
  }
}


# Associates the VPC with the TGW Spoke Route Table, and update the TGW Hub Route Table with the VPC CIDR Block     # Need to Fix IT
module "tgw_association" {
  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-tgw-rt-association"


  vpc_name      = module.workload_private.name
  tgw_attach_id = aws_ec2_transit_gateway_vpc_attachment.vpc.id

  tgw_spoke_route_table_id = var.tgw_spoke_rt_id
  tgw_hub_route_table_id   = var.tgw_hub_rt_id
  vpc_cidr                 = module.workload_private.vpc_cidr
  create_inspection        = var.create_inspection_routing
  tgw_route_table_id       = var.tgw_route_table_id # When i have inspection vpc and using tgw_spoke and tg_hub var.tgw_route_table_id=var.tgw_hub_rt_id ! Need to replace this
}

resource "aws_route" "private_subnets_all_to_tgw" {
  count                  = length(module.workload_private.private_route_table_ids)
  route_table_id         = element(module.workload_private.private_route_table_ids, count.index)
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc]
}

resource "aws_route" "tgw_subnets_all_to_tgw" {
  count                  = length(module.workload_private.tgw_route_table_ids)
  route_table_id         = element(module.workload_private.tgw_route_table_ids, count.index)
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc]
}

# Update Inspection VPC (Private and Public) RTs with the Workload VPC CIDR Block
module "update_inspection_vpc_rt" {
  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-update-inspection-rts"

  count = var.create_inspection_routing ? 1 : 0

  vpc_cidr = module.workload_private.vpc_cidr
  tgw_id   = data.aws_ec2_transit_gateway.tgw.id


  inspection_private_rt_ids = data.aws_route_tables.inspection_private_rts[0].ids
  inspection_public_rt_ids  = [data.aws_route_table.inspection_pub_rt_a[0].id, data.aws_route_table.inspection_pub_rt_b[0].id]
  gwlb_endpoint_ids         = [data.aws_vpc_endpoint.fw-endpoint-a[0].id, data.aws_vpc_endpoint.fw-endpoint-b[0].id]
  aws_fw_endpoint_ids       = [data.aws_vpc_endpoint.fw-endpoint-a[0].id, data.aws_vpc_endpoint.fw-endpoint-b[0].id]
}

# Update Ingress VPC (Private and Public) RTs with the Workload VPC CIDR Block, in order to be accessible from the internet
resource "aws_route" "ingress" {
  for_each = var.create_ingress_routing ? toset(data.aws_route_tables.ingress_rts[0].ids) : toset([])

  route_table_id         = each.value
  destination_cidr_block = module.workload_private.vpc_cidr
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id
}

# Update Egress VPC (Private and Public) RTs with the Workload VPC CIDR Block, in order to access the internet
resource "aws_route" "egress" {
  for_each = var.create_egress_routing ? toset(data.aws_route_tables.egress_rts[0].ids) : toset([])

  route_table_id         = each.value
  destination_cidr_block = module.workload_private.vpc_cidr
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id
}

# Associates the VPC with the TGW Spoke Route Table, and update the TGW Hub Route Table with the VPC CIDR Block     
# module "tgw_association_public_vpc" {
#   source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-tgw-rt-association"

#   count = var.create_central_dns ? 1 : 0

#   vpc_name      = module.public_workload[0].name
#   tgw_attach_id = aws_ec2_transit_gateway_vpc_attachment.public_vpc_attachment[0].id

#   tgw_spoke_route_table_id = var.tgw_spoke_rt_id
#   tgw_hub_route_table_id   = var.tgw_hub_rt_id
#   vpc_cidr                 = module.public_workload[0].vpc_cidr
#   create_inspection        = var.create_inspection_routing
#   tgw_route_table_id       = var.tgw_route_table_id # When i have inspection vpc and using tgw_spoke and tg_hub var.tgw_route_table_id=var.tgw_hub_rt_id ! Need to replace this

#   depends_on = [aws_ec2_transit_gateway_vpc_attachment_accepter.public_vpc_attachment]
# }

# Update Ingress VPC (Private and Public) RTs with the public VPC CIDR Block, in order to be accessible from the internet and routed to Main TGW in Network Account
# resource "aws_route" "update_route_public_cidr_in_ingress" {
#   for_each = var.create_ingress_routing && var.create_central_dns ? toset(data.aws_route_tables.ingress_rts[0].ids) : toset([])

#   route_table_id         = each.value
#   destination_cidr_block = module.public_vpc[0].vpc_cidr
#   transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id
# }

################################################################################
# Route 53
################################################################################
# module "route53_private_zone" { # Create Route 53 Hosted Zone and attavh to private workload vpc
#   source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-lz-hybrid-centralized-dns-management/modules/zones"

#   count = var.create_central_dns ? 1 : 0

#   domain  = var.private_domain_name
#   comment = var.route53_phz_comment
#   private_zones = [{
#     vpc_id     = module.public_vpc[0].vpc_id
#     vpc_region = var.aws_region
#   }]
# }

# # Associate Endpoint VPC to Route 53 Privated Hosted Zone
# resource "aws_route53_vpc_association_authorization" "this" {
#   count = var.create_central_dns ? 1 : 0

#   vpc_id  = data.aws_vpc.endpoint_vpc[0].id
#   zone_id = module.route53_private_zone[0].zone_id
# }

# resource "aws_route53_zone_association" "this" {
#   count = var.create_central_dns ? 1 : 0

#   vpc_id  = data.aws_vpc.endpoint_vpc[0].id
#   zone_id = module.route53_private_zone[0].zone_id
# }


# # Share resolver rule
# resource "aws_ram_resource_share" "route53_rule" {
#   count = var.create_central_dns ? 1 : 0

#   name                      = "Route53_Resolver_Rule_Share"
#   allow_external_principals = false
# }

# resource "aws_ram_resource_association" "route53_rule" {
#   count = var.create_central_dns ? 1 : 0

#   resource_arn       = var.route53_resolver_arn
#   resource_share_arn = aws_ram_resource_share.route53_rule[0].arn
# }

# resource "aws_ram_principal_association" "route53_rule" {
#   count = var.create_central_dns ? 1 : 0

#   principal          = var.aws_account
#   resource_share_arn = aws_ram_resource_share.route53_rule[0].arn
# }

# # Associate public VPC to Resolver Rule
# module "route_resolver_rule" {
#   source  = "terraform-aws-modules/route53/aws//modules/resolver-rule-associations"
#   version = "2.10.2"

#   count = var.create_central_dns ? 1 : 0

#   resolver_rule_associations = {
#     endpoint_vpc = {
#       resolver_rule_id = var.resolver_rule_id
#       vpc_id           = module.public_vpc[0].vpc_id
#     }
#   }
# }
