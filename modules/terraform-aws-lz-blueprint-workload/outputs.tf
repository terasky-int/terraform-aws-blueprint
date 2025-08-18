################################################################################
# VPC Outputs
################################################################################
# Private VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.workload_private.vpc_id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.workload_private.vpc_arn
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.workload_private.private_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.workload_private.database_subnets
}

# TGW
output "tgw_subnets" {
  description = "List of IDs of Transit Gateway Attachment subnets"
  value       = module.workload_private.tgw_subnets
}

################################################################################
# Route 53 Outputs
################################################################################
# output "route53_phz_id" {
#   description = "The ID Route53 PHZ"
#   value       = try(module.route53_private_zone[0].zone_id, null)
# }
