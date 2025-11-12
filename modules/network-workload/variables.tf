variable "environment" {
  description = "The environment name for the workload VPC (e.g., prod, dev)."
  type        = string
}

variable "account_name" {
  description = "The name of the owning account for resource tagging."
  type        = string
}

variable "availability_zones" {
  description = "A list of availability zones in the current region."
  type        = list(string)
}

variable "enable_flow_log" {
  description = "Whether or not to enable VPC Flow Logs"
  type        = bool
}

variable "s3_bucket_name" {
  description = "Central S3 for all network logs usch as vpc flow logs, aws network firewall logs and etc"
  type        = string
  default     = ""
}

variable "workload_vpc_name" {
  description = "The specific name for the workload VPC."
  type        = string
}

variable "workload_vpc_cidr" {
  description = "The CIDR block for the workload VPC."
  type        = string
}

variable "workload_public_subnets_cidr" {
  description = "A list of CIDR blocks for the public subnets."
  type        = list(string)
}

variable "workload_private_subnets_cidr" {
  description = "A list of CIDR blocks for the private subnets."
  type        = list(string)
}

variable "workload_tgw_subnets_cidr" {
  description = "A list of CIDR blocks for the TGW attachment subnets."
  type        = list(string)
}

variable "tgw_id" {
  description = "The ID of the Transit Gateway to attach to. If null, no attachment is created."
  type        = string
  default     = null
}

variable "spoke_tgw_route_table_id" {
  description = "The ID of the Spoke TGW route table to associate with. If null, no association is created."
  type        = string
  default     = null
}

variable "share_with_account_ids" {
  description = "A list of AWS Account IDs to share the created VPC subnets with."
  type        = list(string)
  default     = []
}

# --- TGW ---
variable "create_tgw" {
  description = "Whether to create the Transit Gateway."
  type        = bool
}