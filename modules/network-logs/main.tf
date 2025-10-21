# --------------------------------------------------------------------------------------------------
# S3 Logs
# --------------------------------------------------------------------------------------------------
module "s3_logs_network_firewall" {
  count   = var.enable_flow_log && var.s3_bucket_name != null ? 1 : 0
  source  = "terraform-aws-modules/s3-bucket/aws"

  create_bucket = true
  bucket        = var.s3_bucket_name
  force_destroy = true

  block_public_acls   = true
  block_public_policy = true

  attach_policy = true
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AWSLogDeliveryWrite",
        "Effect" : "Allow",
        "Principal" : { "Service" : "delivery.logs.amazonaws.com" },
        "Action" : "s3:PutObject",
        "Resource" : [
          "${module.s3_logs_network_firewall[0].s3_bucket_arn}/*"
        ]
        # "Condition" : { "StringEquals" : { "aws:SourceAccount" : "${var.aws_account}" } }
      },
      {
        "Sid" : "AWSLogDeliveryAclCheck",
        "Effect" : "Allow",
        "Principal" : { "Service" : "delivery.logs.amazonaws.com" },
        "Action" : "s3:GetBucketAcl",
        "Resource" : "${module.s3_logs_network_firewall[0].s3_bucket_arn}"
      }
    ]
  })
}