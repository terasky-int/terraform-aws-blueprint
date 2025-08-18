terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      #      configuration_aliases = [aws.network, aws.dest]
    }
  }
  cloud {
  }
}

provider "aws" {
  alias  = "network"
  region = var.aws_region

  dynamic "assume_role" {
    for_each = var.network_account != null && var.assume_role_name != null ? ["arn:aws:iam::${var.network_account}:role/${var.assume_role_name}"] : []
    content {
      role_arn = assume_role.value
    }
  }

  default_tags {
    tags = merge(
      {
        Terraform   = "true"
        Environment = var.environment
        RequestedBy = "andreyv@terasky.com"
        Owner       = "CloudPlatform"
        Expiration  = "XXXXXXXXXX"
        MAP_ID      = "XXXXXXXXXX"
        Created_By  = "andreyv@terasky.com"
        Project     = "AWS_LZ_Blueprint+PRESK"
      },
    )
  }
}

provider "aws" {
  alias  = "dest"
  region = var.aws_region

  dynamic "assume_role" {
    for_each = var.destination_account != null && var.assume_role_name != null ? ["arn:aws:iam::${var.destination_account}:role/${var.assume_role_name}"] : []
    content {
      role_arn = assume_role.value
    }
  }

  default_tags {
    tags = merge(
      {
        Terraform   = "true"
        Environment = var.environment
        RequestedBy = "andreyv@terasky.com"
        Owner       = "CloudPlatform"
        Expiration  = "XXXXXXXXXX"
        MAP_ID      = "XXXXXXXXXX"
        Created_By  = "andreyv@terasky.com"
        Project     = "AWS_LZ_Blueprint+PRESK"
      },
    )
  }
}
