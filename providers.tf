terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
# Default provider for the Hub account (where TGW and other central resources reside).
provider "aws" {
  region = var.aws_region

  dynamic "assume_role" {
    for_each = var.aws_account != null && var.assume_role_name != null ? ["arn:aws:iam::${var.aws_account}:role/${var.assume_role_name}"] : []
    content {
      role_arn = assume_role.value
    }
  }
}

# An aliased provider for the central Networking account.
# This provider will assume a role in that account to create the workload VPCs.
provider "aws" {
  alias  = "networking"
  region = var.aws_region

  dynamic "assume_role" {
    for_each = var.networking_account_id != null && var.assume_role_name != null ? ["arn:aws:iam::${var.networking_account_id}:role/${var.assume_role_name}"] : []
    content {
      role_arn = assume_role.value
    }
  }
}

# An aliased provider for the central Logging account.
# This provider will assume a role in that account to create the workload VPCs.
provider "aws" {
  alias  = "logging"
  region = var.aws_region

  dynamic "assume_role" {
    for_each = var.logging_account_id != null && var.assume_role_name != null ? ["arn:aws:iam::${var.logging_account_id}:role/${var.assume_role_name}"] : []
    content {
      role_arn = assume_role.value
    }
  }
}
