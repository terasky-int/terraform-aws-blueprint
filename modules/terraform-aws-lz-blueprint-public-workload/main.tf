################################################################################
# Locals
################################################################################

locals {
  public_vpc_name = "${var.environment}-${var.account_name}-${var.vpc_name}-VPC"
}

################################################################################
# VPC
################################################################################
module "public_workload" {
  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-vpc"

  vpc_name                  = local.public_vpc_name
  vpc_cidr                  = var.vpc_cidr
  create_inspection_routing = var.create_inspection_routing


  tgw_subnet_cidrs     = var.tgw_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  private_subnet_names = var.private_subnet_names
  public_subnet_cidrs  = var.public_subnet_cidrs
  public_subnet_names  = var.public_subnet_names

  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  single_nat_gateway     = var.single_nat_gateway
  enable_nat_gateway     = var.enable_nat_gateway

  # Enable VPC Flow Logs
  enable_flow_log          = var.enable_flow_log
  flow_log_destination_arn = "${var.flow_log_destination_arn}/${var.vpc_name}/"

  public_subnet_tags = var.public_subnet_tags

}

# TGW Attachment to Private VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc" {
  subnet_ids         = module.public_workload.tgw_subnets
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
  vpc_id             = module.public_workload.vpc_id

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = {
    Name = format("%s-TGW-Attachment", module.public_workload.name)
  }
}

# Associates the VPC with the TGW Spoke Route Table, and update the TGW Hub Route Table with the VPC CIDR Block     
module "tgw_association" {
  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-tgw-rt-association"


  vpc_name      = module.public_workload.name
  tgw_attach_id = aws_ec2_transit_gateway_vpc_attachment.vpc.id

  tgw_spoke_route_table_id = var.tgw_spoke_rt_id
  tgw_hub_route_table_id   = var.tgw_hub_rt_id
  vpc_cidr                 = module.public_workload.vpc_cidr
  create_inspection        = var.create_inspection_routing
  tgw_route_table_id       = var.tgw_hub_rt_id
}

resource "aws_route" "private_subnets_all_to_tgw" {
  count                  = var.create_inspection_routing ? length(module.public_workload.private_route_table_ids) : 0
  route_table_id         = element(module.public_workload.private_route_table_ids, count.index)
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc]
}

resource "aws_route" "tgw_subnets_all_to_tgw" {
  count                  = var.create_inspection_routing ? length(module.public_workload.private_route_table_ids) : 0
  route_table_id         = element(module.public_workload.tgw_route_table_ids, count.index)
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc]
}

# Update Inspection VPC (Private and Public) RTs with the Workload VPC CIDR Block
module "update_inspection_vpc_rt" {
  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-update-inspection-rts"

  count = var.create_inspection_routing ? 1 : 0

  vpc_cidr    = module.public_workload.vpc_cidr
  tgw_id      = data.aws_ec2_transit_gateway.tgw.id
  create_gwlb = var.create_gwlb_routing


  inspection_private_rt_ids = data.aws_route_tables.inspection_private_rts[0].ids
  inspection_public_rt_ids  = [data.aws_route_table.inspection_pub_rt_a[0].id, data.aws_route_table.inspection_pub_rt_b[0].id, data.aws_route_table.inspection_pub_rt_c[0].id]
  gwlb_endpoint_ids         = [data.aws_vpc_endpoint.fw-endpoint-a[0].id, data.aws_vpc_endpoint.fw-endpoint-b[0].id, data.aws_vpc_endpoint.fw-endpoint-c[0].id]
  aws_fw_endpoint_ids       = [data.aws_vpc_endpoint.fw-endpoint-a[0].id, data.aws_vpc_endpoint.fw-endpoint-b[0].id, data.aws_vpc_endpoint.fw-endpoint-c[0].id]
}

# Update Ingress VPC (Private and Public) RTs with the Workload VPC CIDR Block, in order to be accessible from the internet
resource "aws_route" "ingress" {
  for_each = var.create_ingress_routing ? toset(data.aws_route_tables.ingress_rts[0].ids) : toset([])

  route_table_id         = each.value
  destination_cidr_block = module.public_workload.vpc_cidr
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id
}

# Update Egress VPC (Private and Public) RTs with the Workload VPC CIDR Block, in order to access the internet
resource "aws_route" "egress" {
  for_each = var.create_egress_routing ? toset(data.aws_route_tables.egress_rts[0].ids) : toset([])

  route_table_id         = each.value
  destination_cidr_block = module.public_workload.vpc_cidr
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id
}
