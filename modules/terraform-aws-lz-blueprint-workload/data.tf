################################################################################
# Data Sources
################################################################################
data "aws_availability_zones" "zones" {
  filter {
    name   = "region-name"
    values = [var.aws_region]
  }
}

output "region_availability_zones" {
  value = data.aws_availability_zones.zones.zone_ids

}

data "aws_ec2_transit_gateway" "tgw" {
  filter {
    name   = "owner-id"
    values = [var.aws_account]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

# Updates Inspection VPC Route Tables with the VPC CIDR Block, depends of whether there is an Inspection VPC in the ENV
data "aws_vpc" "inspection" {
  count = var.create_inspection_routing ? 1 : 0

  cidr_block = var.inspection_vpc_cidr
}

# Gets Private Route Tables for updating them later with the Update Inspection RTs module
data "aws_route_tables" "inspection_private_rts" {
  count = var.create_inspection_routing ? 1 : 0

  vpc_id = data.aws_vpc.inspection[0].id

  filter {
    name   = "tag:Tier"
    values = ["private"]
  }
}

# Gets Public Route Tables for updating them later with the Update Inspection RTs module, use data block per RT because we need to match AZs (there might be a better option)
data "aws_route_table" "inspection_pub_rt_a" {
  count = var.create_inspection_routing ? 1 : 0

  vpc_id = data.aws_vpc.inspection[0].id

  filter {
    name   = "tag:Tier"
    values = ["public"]
  }
  filter {
    name = "tag:Name"
    # values = ["*${var.aws_region}a*"]
    # values = ["*ilc1-az1*"]
    values = ["*${data.aws_availability_zones.zones.zone_ids[0]}*"]
  }
}

# Gets Public Route Tables for updating them later with the Update Inspection RTs module, use data block per RT because we need to match AZs (there might be a better option)
data "aws_route_table" "inspection_pub_rt_b" {
  count = var.create_inspection_routing ? 1 : 0

  vpc_id = data.aws_vpc.inspection[0].id

  filter {
    name   = "tag:Tier"
    values = ["public"]
  }
  filter {
    name   = "tag:Name"
    values = ["*${data.aws_availability_zones.zones.zone_ids[1]}*"]
  }
}
data "aws_route_table" "inspection_pub_rt_c" {
  count = var.create_inspection_routing ? 1 : 0

  vpc_id = data.aws_vpc.inspection[0].id

  filter {
    name   = "tag:Tier"
    values = ["public"]
  }
  filter {
    name   = "tag:Name"
    values = ["*${data.aws_availability_zones.zones.zone_ids[2]}*"]
  }
}

# Single data source per GWLB Endpoint because there is no data block for multiple (VPC) Endpoints
data "aws_vpc_endpoint" "fw-endpoint-a" {
  count = var.create_inspection_routing && var.create_gwlb_routing ? 1 : 0

  vpc_id = data.aws_vpc.inspection[0].id

  filter {
    name   = "vpc-endpoint-type"
    values = ["GatewayLoadBalancer"]
  }

  filter {
    name   = "tag:Name"
    values = ["*${var.aws_region}a*"]
  }
}

# Single data source per GWLB Endpoint because there is no data block for multiple (VPC) Endpoints
data "aws_vpc_endpoint" "fw-endpoint-b" {
  count = var.create_inspection_routing && var.create_gwlb_routing ? 1 : 0

  vpc_id = data.aws_vpc.inspection[0].id

  filter {
    name   = "vpc-endpoint-type"
    values = ["GatewayLoadBalancer"]
  }

  filter {
    name   = "tag:Name"
    values = ["*${var.aws_region}b*"]
  }
}
# Single data source per GWLB Endpoint because there is no data block for multiple (VPC) Endpoints
data "aws_vpc_endpoint" "fw-endpoint-c" {
  count = var.create_inspection_routing && var.create_gwlb_routing ? 1 : 0

  vpc_id = data.aws_vpc.inspection[0].id

  filter {
    name   = "vpc-endpoint-type"
    values = ["GatewayLoadBalancer"]
  }

  filter {
    name   = "tag:Name"
    values = ["*${var.aws_region}c*"]
  }
}

# Updates Ingress VPC Route Tables with the VPC CIDR Block
data "aws_vpc" "ingress" {
  count = var.create_ingress_routing ? 1 : 0

  cidr_block = var.ingress_vpc_cidr
}

data "aws_route_tables" "ingress_rts" {
  count = var.create_ingress_routing ? 1 : 0

  vpc_id = data.aws_vpc.ingress[0].id

  # All RTs without the default VPC RT (Main)
  filter {
    name   = "association.main"
    values = ["false"]
  }
}

# Updates Ingress VPC Route Tables with the VPC CIDR Block
data "aws_vpc" "egress" {
  count = var.create_egress_routing ? 1 : 0

  cidr_block = var.egress_vpc_cidr
}

data "aws_route_tables" "egress_rts" {
  count = var.create_egress_routing ? 1 : 0

  vpc_id = data.aws_vpc.egress[0].id

  # All RTs without the default VPC RT (Main)
  filter {
    name   = "association.main"
    values = ["false"]
  }
}

# # Get ENDPOINT VPC
# data "aws_vpc" "endpoint_vpc" {
#   count = var.create_central_dns ? 1 : 0

#   cidr_block = var.endpoint_vpc_cidr
# }
