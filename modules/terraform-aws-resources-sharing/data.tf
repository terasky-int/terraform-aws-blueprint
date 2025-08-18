################################################################################
# Data Sources
################################################################################

data "aws_default_tags" "default" {
  provider = aws.network
}

data "aws_vpc" "selected" {
  provider = aws.network

  #  id = var.vpc_id
  cidr_block = var.vpc_cidr
  # tags = merge(
  #   data.aws_default_tags.default.tags,
  #   {
  #     Environment = var.environment
  #   }
  # )
}

data "aws_subnets" "all" {
  provider = aws.network

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

data "aws_subnet" "all" {
  provider = aws.network

  for_each = toset(data.aws_subnets.all.ids)
  id       = each.value
}

data "aws_ec2_transit_gateway" "selected" {
  provider = aws.network

  filter {
    name   = "owner-id"
    values = [var.network_account]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}
