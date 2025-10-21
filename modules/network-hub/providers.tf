terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Data source to get the current AWS region
data "aws_region" "current" {}
