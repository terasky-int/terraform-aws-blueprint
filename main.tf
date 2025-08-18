module "aws_network" {
    source = "./modules/terraform-aws-lz-blueprint-network"

    aws_account = var.aws_account
    account_name = var.account_name
    aws_region = var.aws_region
    enable_flow_log = var.enable_flow_log
    endpoint_vpc_cidr = var.endpoint_vpc_cidr
    endpoint_vpc_name = var.endpoint_vpc_name
    endpoint_private_subnet_cidrs = var.endpoint_private_subnet_cidrs
    endpoint_tgw_subnet_cidrs = var.endpoint_tgw_subnet_cidrs
    environment = var.environment
    ingress_vpc_name = var.ingress_vpc_name
    ingress_vpc_cidr = var.ingress_vpc_cidr
    ingress_private_subnet_cidrs = var.ingress_private_subnet_cidrs
    inspection_private_subnet_cidrs = var.ingress_private_subnet_cidrs
    inspection_public_subnet_cidrs = var.inspection_public_subnet_cidrs
    create_aws_fw = var.create_aws_fw
    create_aws_vpn_gateway = var.create_aws_fw
    create_central_dns = var.create_aws_fw
    create_fw_tools_vpc = var.create_aws_fw
    create_gwlb = var.create_gwlb
    create_inspection = var.create_inspection
    create_netwrok_firewall = var.create_netwrok_firewall
    create_phz = var.create_phz
}

module "aws-workload" {
    source = "./modules/terraform-aws-lz-blueprint-workload"
    
    aws_account = var.aws_account
    account_name = var.account_name
    aws_region = var.aws_region
    environment = var.environment
    enable_flow_log = var.enable_flow_log
    vpc_cidr = var.private_vpc_cidr
    vpc_name = var.private_vpc_name
    create_egress_routing = var.create_egress_routing
    create_ingress_routing = var.create_ingress_routing
    create_gwlb_routing = var.create_gwlb_routing
    create_inspection_routing = var.create_inspection_routing
    private_subnet_cidrs = var.private_subnet_cidrs
}

module "aws-public-workload" {
    source = "./modules/terraform-aws-lz-blueprint-public-workload"
    
    aws_account = var.aws_account
    account_name = var.account_name
    aws_region = var.aws_region
    environment = var.environment
    enable_flow_log = var.enable_flow_log
}