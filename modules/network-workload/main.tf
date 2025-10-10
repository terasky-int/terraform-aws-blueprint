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
  tags                                            = { Name = "${var.workload_vpc_name}-vpc-attachment" }
}

resource "aws_ec2_transit_gateway_route_table_association" "workload" {
  # FIX: Only create the association if the attachment is also created.
  count = var.tgw_id != null ? 1 : 0

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload[0].id
  transit_gateway_route_table_id = var.spoke_tgw_route_table_id
}
