terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source = "hashicorp/tls"
      # version = "= 4.0.5"
    }
  }
  # cloud {
  # }
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
        Owner       = "CloudPlatform"
        Expiration  = "XXXXXXXXXX"
        MAP_ID      = "XXXXXXXXXX"
        Created_By  = "andreyv@terasky.com"
        Project     = "AWS_LZ_Blueprint+PRESK"
      },
      #      var.map_server_id != null ? { map-migrated = var.map_server_id } : {}
    )
  }
}

provider "aws" {
  alias  = "log_archived"
  region = var.aws_region

  dynamic "assume_role" {
    for_each = var.aws_account_log_archived != null && var.assume_role_name != null ? ["arn:aws:iam::${var.aws_account_log_archived}:role/${var.assume_role_name}"] : []
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
      #      var.map_server_id != null ? { map-migrated = var.map_server_id } : {}
    )
  }
}
