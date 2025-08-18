terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
  }
}

provider "aws" {
  region = var.aws_region

  dynamic "assume_role" {
    for_each = var.aws_account != null && var.assume_role_name != null ? ["arn:aws:iam::${var.aws_account}:role/${var.assume_role_name}"] : []
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
        Owner       = "IT"
        Created_By  = "andreyv@terasky.com"
        Project     = "AWS_LandingZone"

      },
      #      var.map_server_id != null ? { map-migrated = var.map_server_id } : {}
    )
  }
}
