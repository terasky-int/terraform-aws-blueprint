# Data source to get the current AWS region
data "aws_region" "current" {}

# Data source to get the list of available Availability Zones (AZs) in the specified region.
data "aws_availability_zones" "available" {
  state = "available"
}

# --------------------------------------------------------------------------------------------------
# Workload VPC Module
# --------------------------------------------------------------------------------------------------
module "workload_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.environment}-${var.account_name}-${var.workload_vpc_name}-VPC"
  cidr = var.workload_vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, length(var.workload_public_subnets_cidr))
  public_subnets  = var.workload_public_subnets_cidr
  private_subnets = var.workload_private_subnets_cidr
  # Using the 'database' subnets input for TGW attachments as it creates dedicated route tables
  database_subnets = var.workload_tgw_subnets_cidr

  enable_nat_gateway   = true
  single_nat_gateway   = false # Create NATs in each AZ for high availability
  enable_dns_hostnames = true

  tags                 = { Terraform = "true", Environment = "workload" }
  database_subnet_tags = { Name = "tgw-subnet" }
  public_subnet_tags   = { Name = "public-subnet" }
  private_subnet_tags  = { Name = "private-subnet" }

  enable_flow_log      = var.enable_flow_log
  
}

# --------------------------------------------------------------------------------------------------
# TGW VPC Attachment & Association (Conditional)
# --------------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "workload" {
  # FIX: Only create the attachment if a valid TGW ID is provided.
  count = var.tgw_id != null ? 1 : 0

  vpc_id     = module.workload_vpc.vpc_id
  subnet_ids = module.workload_vpc.database_subnets

  transit_gateway_id                              = var.tgw_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  
  tags = {
    Name        = "${var.environment}-${var.workload_vpc_name}-tgw-attachment"
    Environment = var.environment
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "workload" {
  # FIX: Only create the association if the attachment is also created.
  count = var.tgw_id != null ? 1 : 0

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload[0].id
  transit_gateway_route_table_id = var.spoke_tgw_route_table_id

  depends_on = [ aws_ec2_transit_gateway_vpc_attachment.workload ]
}

# --------------------------------------------------------------------------------------------------
# AWS RAM for VPC Sharing
# --------------------------------------------------------------------------------------------------
locals {
  # Combine all subnet IDs into a single list
  all_subnets = concat(
    module.workload_vpc.public_subnets,
    module.workload_vpc.private_subnets,
    module.workload_vpc.database_subnets
  )

  # Create a map where keys are static indices ("0", "1", "2", etc.)
  # and values are the apply-time subnet IDs. This is required to solve the
  # "invalid for_each argument" error where for_each cannot iterate on a set
  # of values that are unknown at plan time.
  subnet_map_for_ram = {
    for i, subnet_id in local.all_subnets : tostring(i) => subnet_id
  }
}

resource "aws_ram_resource_share" "vpc_share" {
  name                      = "${var.environment}-${var.workload_vpc_name}-share"
  allow_external_principals = false

  tags = {
    Name        = "${var.environment}-${var.workload_vpc_name}-share"
    Environment = var.environment
  }
}

# Associate all subnets created in the VPC with the RAM share
resource "aws_ram_resource_association" "subnet_associations" {
  # FIX: Iterate over the local map with static keys instead of the direct subnet list.
  for_each = local.subnet_map_for_ram
  # FIX: Correctly reference the AWS region from the data source and use each.value for the subnet ID.
  resource_arn       = "arn:aws:ec2:${data.aws_region.current.id}:${module.workload_vpc.vpc_owner_id}:subnet/${each.value}"
  resource_share_arn = aws_ram_resource_share.vpc_share.arn
}

# Share the resources with the specified AWS account principals
resource "aws_ram_principal_association" "account_associations" {
  for_each           = toset(var.share_with_account_ids)
  principal          = each.key
  resource_share_arn = aws_ram_resource_share.vpc_share.arn
}
