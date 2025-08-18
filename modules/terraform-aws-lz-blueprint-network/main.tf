locals {
  inspection_vpc_name = "${var.environment}-${var.account_name}-${var.inspection_vpc_name}-VPC"
  ingress_vpc_name    = "${var.environment}-${var.account_name}-${var.ingress_vpc_name}-VPC"
  egress_vpc_name     = "${var.environment}-${var.account_name}-${var.egress_vpc_name}-VPC"
  endpoint_vpc_name   = "${var.environment}-${var.account_name}-${var.endpoint_vpc_name}-VPC"
  fw_tools_vpc_name   = "${var.environment}-${var.account_name}-${var.fw_tools_vpc_name}-VPC"
  gwlb_name           = "${var.environment}-${var.account_name}-${var.gwlb_name}-GWLB"
  tgw_name            = "${var.environment}-${var.account_name}-TGW"
}

################################################################################
# TGW
################################################################################

module "tgw" {
  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-tgw"

  tgw_name          = local.tgw_name
  create_inspection = var.create_inspection

  tgw_tags = {
    Name = local.tgw_name
  }
}

################################################################################
# Inspection VPC
################################################################################
# # This VPC role is for Inspection and Egress networking. var.inspection is a boolean which determines whether there is a FW in the env or not.
module "inspection_vpc" {
  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-network-firewall-vpc/vpc"

  count = var.create_inspection ? 1 : 0

  vpc_name = local.inspection_vpc_name
  vpc_cidr = var.inspection_vpc_cidr


  firewall_subnet_cidrs = var.firewall_subnet_cidrs
  public_subnet_cidrs   = var.inspection_public_subnet_cidrs
  tgw_subnet_cidrs      = var.inspection_tgw_subnet_cidrs
  private_subnet_cidrs  = var.inspection_private_subnet_cidrs

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  enable_flow_log          = var.enable_flow_log
  flow_log_destination_arn = "${module.s3_logs_network_firewall[0].s3_bucket_arn}/${local.inspection_vpc_name}/"

  tgw_route_table_tags = {
    Tier       = "tgw-attachment"
    Inspection = "true"
  }
}

# TGW VPC Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "inspection_vpc" {
  count = var.create_inspection ? 1 : 0

  subnet_ids                                      = module.inspection_vpc[0].tgw_subnets
  transit_gateway_id                              = module.tgw.id
  vpc_id                                          = module.inspection_vpc[0].vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  appliance_mode_support                          = "enable"

  tags = {
    Name = format("%s-TGW-Attachment", module.inspection_vpc[0].name)
  }
}

# Associates the Inspection VPC with the TGW Hub Route Table, and update the TGW Spoke Route Table with 0.0.0.0/0 CIDR Block
module "inspection_tgw_rt" {

  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-tgw-rt-association"
  count  = var.create_inspection ? 1 : 0

  vpc_name      = module.inspection_vpc[0].name
  tgw_attach_id = aws_ec2_transit_gateway_vpc_attachment.inspection_vpc[0].id
  #  tgw_accept    = false
  is_inspection     = var.create_inspection
  create_inspection = var.create_inspection

  tgw_spoke_route_table_id = module.tgw.tgw_spoke_route_table_id
  tgw_hub_route_table_id   = module.tgw.tgw_hub_route_table_id
  vpc_cidr                 = module.inspection_vpc[0].vpc_cidr

  # The depends_on is necessary here because sometimes the VPC Attachments can take time to be created, TF have to wait until then
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.inspection_vpc]
}

# The customer needs to choose whether to use AWS Network Firewall or a Vendor Firewall with Gateway Load Balancer
module "gwlb" {
  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-gwlb"
  count  = var.create_inspection && var.create_gwlb ? 1 : 0

  vpc_name            = module.inspection_vpc[0].name
  gwlb_name           = local.gwlb_name
  vpc_id              = module.inspection_vpc[0].vpc_id
  private_subnets     = module.inspection_vpc[0].private_subnets
  tgw_route_table_ids = module.inspection_vpc[0].tgw_route_table_ids
}

# ################################################################################
# # AWS Netwrok Firewall
# ################################################################################
# module "network_firewall" {
#   source = "git@github.com:terasky-int/terraform-aws-network-firewall.git"

#   count = var.create_aws_fw && var.create_inspection ? 1 : 0

#   firewall_name  = var.anfw_name
#   policy_name    = var.anfw_policy_name
#   vpc_id         = module.inspection_vpc[0].vpc_id
#   subnet_mapping = module.inspection_vpc[0].firewall_subnet_ids

#   #  Logging Config 
#   bucket_name_logging = module.s3_logs_network_firewall[0].s3_bucket_id # Store flow logs to s3 on log archived account
#   s3_logs_prefix      = var.anfw_name


#   # Routes
#   route_for_tgw_route_table_ids    = module.inspection_vpc[0].tgw_route_table_ids
#   route_for_public_route_table_ids = module.inspection_vpc[0].public_route_table_ids
#   inspection_vpc_igw_id            = module.inspection_vpc[0].igw_id

#   # Rules Config 
#   # Stateless Rule Config 
#   stateless_rule_group = var.stateless_rule_group
#   # 5-Tuple Config 
#   fivetuple_stateful_rule_group = var.fivetuple_stateful_rule_group

#   # Suricata Rule Config
#   suricata_stateful_rule_group = var.suricata_stateful_rule_group

#   # Domain Rule Config 
#   domain_stateful_rule_group = var.domain_stateful_rule_group

#   depends_on = [
#     module.inspection_vpc
#   ]
# }

################################################################################
# Endpoint VPC
################################################################################

module "endpoint_vpc" {
  # source = "git@github.com:terasky-int/terraform-aws-vpc.git?ref=v1.3"
  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-vpc.git"

  vpc_name = local.endpoint_vpc_name
  vpc_cidr = var.endpoint_vpc_cidr

  tgw_subnet_cidrs     = var.endpoint_tgw_subnet_cidrs
  private_subnet_cidrs = var.endpoint_private_subnet_cidrs

  enable_flow_log          = var.enable_flow_log
  flow_log_destination_arn = "${module.s3_logs_network_firewall[0].s3_bucket_arn}/${local.endpoint_vpc_name}/"
}

# TGW VPC Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "endpoint_vpc" {
  subnet_ids                                      = module.endpoint_vpc.tgw_subnets
  transit_gateway_id                              = module.tgw.id
  vpc_id                                          = module.endpoint_vpc.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  appliance_mode_support                          = "disable"

  tags = {
    Name = format("%s-TGW-Attachment", module.endpoint_vpc.name)
  }
}

# Associates the Endpoint VPC with the TGW Spoke Route Table, and update the TGW Hub Route Table with the Endpoint VPC CIDR Block
module "endpoint_tgw_rt" {
  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-tgw-rt-association"
  #  version = "1.0"

  vpc_name      = module.endpoint_vpc.name
  tgw_attach_id = aws_ec2_transit_gateway_vpc_attachment.endpoint_vpc.id
  #  tgw_accept    = false
  #  is_inspection = false
  create_inspection = var.create_inspection

  tgw_spoke_route_table_id = module.tgw.tgw_spoke_route_table_id
  tgw_hub_route_table_id   = module.tgw.tgw_hub_route_table_id
  tgw_route_table_id       = module.tgw.tgw_route_table_id
  vpc_cidr                 = module.endpoint_vpc.vpc_cidr

  # The depends_on is necessary here because VPC Attachments can take time to be created, TF have to wait until then
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.endpoint_vpc]
}

# Update Route Tables to forward all requests into the central TGW (relevant to all VPCs but Inspection VPC)
resource "aws_route" "endpoint_all_to_tgw" {
  count = length(flatten(concat(module.endpoint_vpc.private_route_table_ids, module.endpoint_vpc.tgw_route_table_ids)))

  route_table_id         = flatten(concat(module.endpoint_vpc.private_route_table_ids, module.endpoint_vpc.tgw_route_table_ids))[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = module.tgw.id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.endpoint_vpc] # [module.tgw_association]
}

# Updates Inspection VPC Route Tables with Endpoint VPC CIDR Block
module "endpoint_vpc_update_inspection_vpc_rt_gwlb" {
  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-update-inspection-rts"

  count = var.create_inspection && var.create_gwlb ? 1 : 0

  #  is_inspection             = var.inspection_vpc_is_inspection # remove this for any other vpc
  vpc_cidr                  = module.endpoint_vpc.vpc_cidr
  tgw_id                    = module.tgw.id
  inspection_tgw_rt_ids     = module.inspection_vpc[0].tgw_route_table_ids # remove this for any other vpc
  inspection_private_rt_ids = module.inspection_vpc[0].private_route_table_ids
  inspection_public_rt_ids  = module.inspection_vpc[0].public_route_table_ids
  gwlb_endpoint_ids         = module.gwlb[0].gwlb_vpc_endpoint_ids

  # The depends_on is necessary here because the GWLB can take time to be available, TF have to wait until then
  depends_on = [module.gwlb]
}

module "endpoint_vpc_update_inspection_vpc_rt_aws_fw" {
  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-update-inspection-rts"

  count = var.create_inspection && var.create_aws_fw ? 1 : 0

  #  is_inspection             = var.inspection_vpc_is_inspection # remove this for any other vpc
  vpc_cidr                  = module.endpoint_vpc.vpc_cidr
  tgw_id                    = module.tgw.id
  inspection_tgw_rt_ids     = module.inspection_vpc[0].tgw_route_table_ids # remove this for any other vpc
  inspection_private_rt_ids = module.inspection_vpc[0].private_route_table_ids
  inspection_public_rt_ids  = module.inspection_vpc[0].public_route_table_ids
  # aws_fw_endpoint_ids       = module.network_firewall[0].endpoint_ids

  # The depends_on is necessary here because the GWLB can take time to be available, TF have to wait until then
  # depends_on = [module.network_firewall]
}

################################################################################
# ingress VPC
################################################################################

module "ingress_vpc" { # Need to check here why var.ingress_tgw_subnet_cidrs is marked!
  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-vpc"

  vpc_name = local.ingress_vpc_name
  vpc_cidr = var.ingress_vpc_cidr

  #  tgw_subnet_cidrs         = var.ingress_tgw_subnet_cidrs
  private_subnet_cidrs = var.ingress_private_subnet_cidrs
  public_subnet_cidrs  = var.ingress_public_subnet_cidrs

  enable_flow_log          = var.enable_flow_log
  flow_log_destination_arn = "${module.s3_logs_network_firewall[0].s3_bucket_arn}/${local.ingress_vpc_name}/"

}

# TGW VPC Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "ingress_vpc" {
  subnet_ids                                      = module.ingress_vpc.private_subnets
  transit_gateway_id                              = module.tgw.id
  vpc_id                                          = module.ingress_vpc.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  appliance_mode_support                          = "disable"

  tags = {
    Name = format("%s-TGW-Attachment", module.ingress_vpc.name)
  }
}

# Associates the Ingress VPC with the TGW Spoke Route Table, and update the TGW Hub Route Table with the Ingress VPC CIDR Block
module "ingress_tgw_rt" {
  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-tgw-rt-association"

  vpc_name      = module.ingress_vpc.name
  tgw_attach_id = aws_ec2_transit_gateway_vpc_attachment.ingress_vpc.id
  #  tgw_accept    = false
  #  is_inspection = false
  create_inspection = var.create_inspection

  tgw_spoke_route_table_id = module.tgw.tgw_spoke_route_table_id
  tgw_hub_route_table_id   = module.tgw.tgw_hub_route_table_id
  tgw_route_table_id       = module.tgw.tgw_route_table_id
  vpc_cidr                 = module.ingress_vpc.vpc_cidr

  # The depends_on is necessary here because VPC Attachments can take time to be created, TF have to wait until then
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.ingress_vpc]
}

################################################################################
# Egress VPC
################################################################################

module "egress_vpc" {

  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-vpc"

  count = var.create_inspection ? 0 : 1

  vpc_name = local.egress_vpc_name
  vpc_cidr = var.egress_vpc_cidr

  #  tgw_subnet_cidrs         = var.egress_tgw_subnet_cidrs
  private_subnet_cidrs = var.egress_private_subnet_cidrs
  public_subnet_cidrs  = var.egress_public_subnet_cidrs

  enable_nat_gateway     = true
  one_nat_gateway_per_az = true

  enable_flow_log          = var.enable_flow_log
  flow_log_destination_arn = "${module.s3_logs_network_firewall[0].s3_bucket_arn}/${local.egress_vpc_name}/"
}

# TGW VPC Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "egress_vpc" {
  count = var.create_inspection ? 0 : 1

  subnet_ids                                      = module.egress_vpc[0].private_subnets
  transit_gateway_id                              = module.tgw.id
  vpc_id                                          = module.egress_vpc[0].vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  appliance_mode_support                          = "disable"

  tags = {
    Name = format("%s-TGW-Attachment", module.egress_vpc[0].name)
  }
}

# Associates the Egress VPC with the TGW Spoke Route Table, and update the TGW Hub Route Table with the Egress VPC CIDR Block
module "egress_tgw_rt" {
  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-tgw-rt-association"

  count = var.create_inspection ? 0 : 1

  vpc_name      = module.egress_vpc[0].name
  tgw_attach_id = aws_ec2_transit_gateway_vpc_attachment.egress_vpc[0].id
  #  tgw_accept    = false
  #  is_inspection = false
  create_inspection = var.create_inspection

  #  tgw_spoke_route_table_id = module.tgw.tgw_spoke_route_table_id
  #  tgw_hub_route_table_id   = module.tgw.tgw_hub_route_table_id
  tgw_route_table_id = module.tgw.tgw_route_table_id
  vpc_cidr           = module.egress_vpc[0].vpc_cidr

  # The depends_on is necessary here because VPC Attachments can take time to be created, TF have to wait until then
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.egress_vpc]
}

################################################################################
# Firewall Tools VPC
################################################################################
module "fw_tools_vpc" {
  # source = "git@github.com:terasky-int/terraform-aws-vpc.git?ref=v1.3"
  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-vpc"
  #  version = "1.1"
  count = var.create_inspection && var.create_gwlb && var.create_fw_tools_vpc ? 1 : 0

  vpc_name = local.fw_tools_vpc_name
  vpc_cidr = var.fw_tools_vpc_cidr

  tgw_subnet_cidrs         = var.fw_tools_tgw_subnet_cidrs
  private_subnet_cidrs     = var.fw_tools_private_subnet_cidrs
  enable_flow_log          = var.enable_flow_log
  flow_log_destination_arn = "${module.s3_logs_network_firewall[0].s3_bucket_arn}/${local.fw_tools_vpc_name}/"

}

# TGW VPC Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "fw_tools_vpc" {
  count = var.create_inspection && var.create_gwlb && var.create_fw_tools_vpc ? 1 : 0

  subnet_ids                                      = module.fw_tools_vpc[0].tgw_subnets
  transit_gateway_id                              = module.tgw.id
  vpc_id                                          = module.fw_tools_vpc[0].vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  appliance_mode_support                          = "disable"

  tags = {
    Name = format("%s-TGW-Attachment", module.fw_tools_vpc[0].name)
  }
}

# Associates the FW Tools VPC with the TGW Spoke Route Table, and update the TGW Hub Route Table with the FW Tools VPC CIDR Block
module "fw_tools_tgw_rt" {
  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-tgw-rt-association"

  count = var.create_inspection && var.create_gwlb && var.create_fw_tools_vpc ? 1 : 0

  vpc_name      = module.fw_tools_vpc[0].name
  tgw_attach_id = aws_ec2_transit_gateway_vpc_attachment.fw_tools_vpc[0].id
  #  tgw_accept    = false
  #  is_inspection = false
  create_inspection = var.create_inspection

  tgw_spoke_route_table_id = module.tgw.tgw_spoke_route_table_id
  tgw_hub_route_table_id   = module.tgw.tgw_hub_route_table_id
  tgw_route_table_id       = module.tgw.tgw_route_table_id
  vpc_cidr                 = module.fw_tools_vpc[0].vpc_cidr

  # The depends_on is necessary here because VPC Attachments can take time to be created, TF have to wait until then
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.fw_tools_vpc]
}

# # Update Route Tables to forward all requests into the central TGW (relevant to all VPCs but Inspection VPC)
resource "aws_route" "fw_tools_all_to_tgw" {
  count = var.create_inspection && var.create_gwlb && var.create_fw_tools_vpc ? length(flatten(concat(module.fw_tools_vpc[0].private_route_table_ids, module.fw_tools_vpc[0].tgw_route_table_ids))) : 0

  route_table_id         = flatten(concat(module.fw_tools_vpc[0].private_route_table_ids, module.fw_tools_vpc[0].tgw_route_table_ids))[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = module.tgw.id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.fw_tools_vpc] # [module.tgw_association]
}

# Updates Inspection VPC Route Tables with FW Tools VPC CIDR Block
module "fw_tools_update_inspection_vpc_rt" {
  source = "git@github.com:terasky-int/terraform-aws-static-modules.git//terraform-aws-update-inspection-rts"
  #  version = "1.0"
  count = var.create_inspection && var.create_gwlb && var.create_fw_tools_vpc ? 1 : 0

  vpc_cidr                  = module.fw_tools_vpc[0].vpc_cidr
  tgw_id                    = module.tgw.id
  inspection_tgw_rt_ids     = module.inspection_vpc[0].tgw_route_table_ids # remove this for any other vpc
  inspection_private_rt_ids = module.inspection_vpc[0].private_route_table_ids
  inspection_public_rt_ids  = module.inspection_vpc[0].public_route_table_ids
  gwlb_endpoint_ids         = module.gwlb[0].gwlb_vpc_endpoint_ids

  depends_on = [module.gwlb]
}

# Updates Ingress and Egress VPCs Route Tables with FW Tools VPC CIDR Block
module "fw_tools_update_ingress_vpc_rt" {
  source = "git@github.com:terasky-int/terraform-aws-lz-update-rt.git//update-ingress-egress-rt"

  count = var.create_inspection && var.create_gwlb && var.create_fw_tools_vpc ? 1 : 0

  vpc_cidr = module.fw_tools_vpc[0].vpc_cidr
  tgw_id   = module.tgw.id

  private_rt_ids = module.ingress_vpc.private_route_table_ids
  public_rt_ids  = module.ingress_vpc.public_route_table_ids

}

module "fw_tools_update_egress_vpc_rt" {
  source = "git@github.com:terasky-int/terraform-aws-lz-update-rt.git//update-ingress-egress-rt"

  count = var.create_inspection && var.create_gwlb && var.create_fw_tools_vpc ? 1 : 0

  vpc_cidr = module.fw_tools_vpc[0].vpc_cidr
  tgw_id   = module.tgw.id

  private_rt_ids = module.egress_vpc[0].private_route_table_ids
  public_rt_ids  = module.egress_vpc[0].public_route_table_ids
}

# Updates Ingress and Egress VPCs Route Tables with FW Tools VPC CIDR Block
resource "aws_route" "fw_tools_ingress" {
  count = var.create_inspection && var.create_gwlb && var.create_fw_tools_vpc ? length(flatten(concat(module.ingress_vpc[0].private_route_table_ids, module.ingress_vpc[0].public_route_table_ids))) : 0

  route_table_id         = flatten(concat(module.ingress_vpc[0].private_route_table_ids, module.ingress_vpc[0].public_route_table_ids))[count.index]
  destination_cidr_block = module.fw_tools_vpc[0].vpc_cidr
  transit_gateway_id     = module.tgw.id
}

resource "aws_route" "fw_tools_egress" {
  count = var.create_inspection && var.create_gwlb && var.create_fw_tools_vpc ? length(flatten(concat(module.egress_vpc[0].private_route_table_ids, module.egress_vpc[0].public_route_table_ids))) : 0

  route_table_id         = flatten(concat(module.egress_vpc[0].private_route_table_ids, module.egress_vpc[0].public_route_table_ids))[count.index]
  destination_cidr_block = module.fw_tools_vpc[0].vpc_cidr
  transit_gateway_id     = module.tgw.id
}

################################################################################
# S3 Logs
################################################################################
module "s3_logs_network_firewall" { # Store AWS Firewall Network logs # Need fix error if this false
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.8.2"

  count = var.enable_flow_log ? 1 : 0

  providers = {
    aws = aws.log_archived
  }

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

# # ################################################################################
# # # AWS VPN S2S
# # ################################################################################
# # module "vpn" {
# #   source = "git@github.com:terasky-int/terraform-aws-lz-vpn-s2s.git"

# #   for_each = { for vpn_gateway in var.vpn_gateways : vpn_gateway.destination_ip_address => vpn_gateway if var.vpn_gateways != [] }

# #   create_aws_vpn_gateway   = var.create_aws_vpn_gateway
# #   bgp_asn                  = each.value.bgp_asn
# #   ip_address               = each.value.destination_ip_address
# #   type                     = var.vpn_type
# #   cgw_name                 = each.value.cgw_name
# #   transit_gateway_id       = module.tgw.id
# #   private_destination_cidr = each.value.private_destination_cidr
# #   routing                  = each.value.s2s_routing


# #   # tunnel inside cidr & preshared keys
# #   tunnel1_preshared_key = var.provided_preshared_key1 == "" ? each.value.tunnel1_preshared_key : var.provided_preshared_key1
# #   tunnel2_preshared_key = var.provided_preshared_key2 == "" ? each.value.tunnel2_preshared_key : var.provided_preshared_key2
# #   tunnel1_inside_cidr   = each.value.tunnel1_inside_cidr
# #   tunnel2_inside_cidr   = each.value.tunnel2_inside_cidr

# #   transit_gateway_route_table_id = module.tgw.tgw_route_table_id
# # }

# ################################################################################
# # Security Groups
# ################################################################################
# module "sg_route_resolver" {
#   source  = "terraform-aws-modules/security-group/aws"
#   version = "5.1.0"

#   count = var.create_central_dns ? 1 : 0

#   name                = "Route53-Resolver-Security-Group"
#   description         = "Route53 Resolver Security-Group - Managed By Terraform"
#   vpc_id              = module.endpoint_vpc.vpc_id
#   ingress_cidr_blocks = concat([module.endpoint_vpc.vpc_cidr], var.allow_additional_cidr_blocks)
#   ingress_rules       = ["dns-udp", "dns-tcp"]
#   egress_cidr_blocks  = ["0.0.0.0/0"]
#   egress_rules        = ["dns-udp", "dns-tcp"]
# }

# ################################################################################
# # Route 53 Hybrid DNS Manegement
# ################################################################################
# module "hybrid_private_dns" {
#   source = "git@github.com:terasky-int/terraform-aws-lz-hybrid-centralized-dns-management.git?ref=v1.1"

#   count = var.create_central_dns ? 1 : 0

#   # Create Private Zone
#   create_phz = var.create_phz
#   domain     = var.private_zone_domain_name
#   comment    = var.private_zone_comment
#   private_zones = [
#     {
#       vpc_id     = module.endpoint_vpc.vpc_id
#       vpc_region = var.aws_region
#   }]
#   additional_vpc = var.additional_vpc

#   # Create Inbound Endpoint
#   inbound_endpoint_direction          = var.inbound_endpoint_direction
#   inbound_endpoint_name               = var.inbound_endpoint_name
#   inbound_endpoint_security_group_ids = [module.sg_route_resolver[0].security_group_id]
#   inbound_endpoint_ip_address         = [for i in range(3) : { subnet_id = module.endpoint_vpc.private_subnets[i] }]

#   # Create Outbound Endpoint
#   outbound_endpoint_direction          = var.outbound_endpoint_direction
#   outbound_endpoint_name               = var.outbound_endpoint_name
#   outbound_endpoint_security_group_ids = [module.sg_route_resolver[0].security_group_id]
#   outbound_endpoint_ip_address         = [for i in range(3) : { subnet_id = module.endpoint_vpc.private_subnets[i] }]

#   # Create Resolver Rule
#   resolver_rules = var.resolver_rules

#   # Associate VPC                                                                
#   resolver_rule_associations = { # Here i have issue that if i have multiple resolver rules how i can excplicit specific one
#     ingress_vpc = {
#       resolver_rule_id = module.hybrid_private_dns[0].resolver_rule_id[0]
#       vpc_id           = module.ingress_vpc.vpc_id
#     }
#   }
# }
