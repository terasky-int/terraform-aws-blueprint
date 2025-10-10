terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Default provider for initial authentication and data source lookup.
# It uses the credentials configured in your environment.
provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

# Configure the AWS Provider
provider "aws" {
  alias  = "assumed_role"
  region = var.aws_region

  dynamic "assume_role" {
    for_each = var.assume_role_name != null ? [1] : []
    content {
      role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.assume_role_name}"
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
