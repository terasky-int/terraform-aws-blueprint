output "vpc_id" {
  description = "The ID of the workload VPC."
  value       = module.workload_vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs in the workload VPC."
  value       = module.workload_vpc.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs in the workload VPC."
  value       = module.workload_vpc.private_subnets
}

output "tgw_attachment_id" {
  description = "The ID of the TGW VPC attachment, if created."
  # FIX: Return null if the attachment was not created.
  value = length(aws_ec2_transit_gateway_vpc_attachment.workload) > 0 ? aws_ec2_transit_gateway_vpc_attachment.workload[0].id : null
}

