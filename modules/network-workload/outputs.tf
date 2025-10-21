output "vpc_id" {
  description = "The ID of the created workload VPC."
  value       = module.workload_vpc.vpc_id
}

output "vpc_arn" {
  description = "The ARN of the created workload VPC."
  value       = module.workload_vpc.vpc_arn
}

output "public_subnets" {
  description = "List of public subnet IDs."
  value       = module.workload_vpc.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs."
  value       = module.workload_vpc.private_subnets
}

output "tgw_attachment_id" {
  description = "The ID of the Transit Gateway VPC attachment."
  value       = var.tgw_id != null ? aws_ec2_transit_gateway_vpc_attachment.workload[0].id : null
}

output "ram_share_arn" {
  description = "The ARN of the RAM resource share used to share the VPC."
  value       = aws_ram_resource_share.vpc_share.arn
}
