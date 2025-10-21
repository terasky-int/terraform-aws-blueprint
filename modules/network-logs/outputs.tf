output "flow_log_bucket_arn" {
  description = "The ARN of the central S3 bucket for VPC flow logs."
  value       = var.enable_flow_log ? module.s3_logs_network_firewall[0].s3_bucket_arn : null
}
