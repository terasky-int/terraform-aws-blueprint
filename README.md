**Terraform AWS Network Hub and Spoke Architecture**

This Terraform project deploys a comprehensive, multi-VPC networking hub on AWS, designed for centralized inspection, egress, ingress, and shared services. It also includes a reusable module to create and share new "workload" VPCs that connect to this hub.

The architecture is built to be modular, scalable, and secure, following AWS best practices for multi-account networking.

**Architecture Overview**

This project creates two main components:

- **The Network Hub (./modules/network-hub):** This is the central transit core of your network. It deploys a **Transit Gateway (TGW)** and a collection of specialized VPCs for different traffic flows:
  - **Inspection VPC:** Contains a firewall (AWS Network Firewall or Gateway Load Balancer) to inspect all traffic between VPCs and to/from the internet.
  - **Egress VPC:** Provides a centralized, controlled exit point for all outbound internet traffic, using NAT Gateways.
  - **Ingress VPC:** Provides a centralized entry point for inbound internet traffic, typically hosting public-facing load balancers.
  - **Endpoint VPC:** Hosts VPC Interface Endpoints (PrivateLink) for accessing AWS services privately.
  - **Firewall Tools VPC:** A dedicated VPC for managing your security appliances or hosting monitoring tools.
- **Workload VPCs (./modules/network-workload):** This is a reusable module that you can use to stamp out new VPCs for your applications. The root main.tf file iterates over a map to create multiple, distinct workload VPCs. Each workload VPC is automatically:
  - **Attached** to the central Transit Gateway as a "spoke."
  - **Associated** with the "spoke" TGW route table, forcing all its traffic through the Inspection VPC's firewall.
  - **Shared** with other AWS accounts (e.g., application accounts) using AWS Resource Access Manager (RAM).
- **Centralized Logging** **(./modules/network-logs):** This is Reusable module to create S3 bucket in a dedicated logging account.

**Project Structure**

.

├── modules

│ ├── network-hub/ # Deploys TGW, all hub VPCs, and the central flow log S3 bucket

│ │ ├── main.tf

│ │ ├── outputs.tf

│ │ ├── providers.tf

│ │ └── variables.tf

│ ├── network-workload/ # Reusable module to create and share a single workload VPC

│ │ ├── main.tf

│ │ ├── outputs.tf

│ │ ├── providers.tf

│ │ └── variables.tf

│ └── network-logs/ # Reusable module to create S3 bucket in a dedicated logging account

│ ├── main.tf

│ ├── outputs.tf

│ ├── providers.tf

│ └── variables.tf

├── main.tf # Root module: configures providers and calls the hub and workload modules.

├── outputs.tf # Root outputs from all modules.

├── terraform.tfvars # Your environment-specific variables (CIDRs, account names, etc.)

├── terraform.tfvars.example # Example variables file to copy from.

├── variables.tf # Root variable definitions.

├── README.md # This file.

└── .gitignore # Standard Terraform gitignore.

**How to Use**

- **Prerequisites:**
  - Terraform 1.0.0+
  - An AWS account designated as the "Networking Account" where the hub will be deployed.
  - An IAM Role (e.g., TerraformExecutionRole) in that account with permissions to create these resources. This role must be assumable by your local user/CI/CD system.
  - (Optional) An AWS account designated as the "Logging Account" with an S3 bucket and a trust policy that allows the Networking account's IAM role to assume a role within it.
- **Configure Your Variables:**
  - Copy terraform.tfvars.example to terraform.tfvars.
  - Fill out all the required variables in terraform.tfvars. Pay close attention to:
    - assume_role_name: The name of the IAM role Terraform will use.
    - logging_account_id: The ID of your dedicated logging account.
    - All VPC and subnet CIDR blocks.
    - workload_vpcs: Define all the application VPCs you want to create here.
- **Deploy the Infrastructure:**
- \# Initialize Terraform to download modules and providers
- terraform init
- \# Plan the deployment to see what will be created
- terraform plan
- \# Apply the configuration
- terraform apply

**Inputs (Root Module Variables)**

These are the variables you must define in your terraform.tfvars file.

| **Name** | **Description** | **Type** | **Default** | **Required** |
| --- | --- | --- | --- | --- |
| account_name | The name of the AWS account. | string | n/a | **yes** |
| assume_role_name | The name of the IAM role to assume for deploying resources. | string | n/a | **yes** |
| aws_region | The AWS region where resources will be created. | string | n/a | **yes** |
| create_endpoint_vpc | Boolean flag to create the Endpoint VPC. | bool | true | no  |
| create_egress_vpc | Boolean flag to create the Egress VPC. | bool | true | no  |
| create_firewall_tools_vpc | Boolean flag to create the Firewall Tools VPC. | bool | true | no  |
| create_ingress_vpc | Boolean flag to create the Ingress VPC. | bool | true | no  |
| create_inspection | Boolean flag to create the Inspection VPC. | bool | true | no  |
| create_s2s_vpn | Boolean flag to create the Site-to-Site VPN connection. | bool | false | no  |
| create_tgw | Boolean flag to create the Transit Gateway. | bool | true | no  |
| customer_bgp_asn | The BGP ASN of the on-premise customer gateway. | number | 65000 | no  |
| customer_gateway_ip | The public IP address of the on-premise customer gateway. | string | null | no  |
| enable_flow_logs | Boolean flag to enable or disable VPC flow logs for all created VPCs. | bool | false | no  |
| enable_hybrid_dns | Boolean flag to enable Route 53 Hybrid DNS. | bool | false | no  |
| endpoint_public_subnets_cidr | List of CIDR blocks for public subnets in the Endpoint VPC. | list(string) | n/a | **yes** |
| endpoint_tgw_subnets_cidr | List of CIDR blocks for TGW attachment subnets in the Endpoint VPC. | list(string) | n/a | **yes** |
| endpoint_vpc_cidr | The CIDR block for the Endpoint VPC. | string | n/a | **yes** |
| endpoint_vpc_name | The specific name for the Endpoint VPC. | string | "endpoint" | no  |
| environment | The deployment environment (e.g., 'dev', 'prod'). | string | n/a | **yes** |
| egress_public_subnets_cidr | List of CIDR blocks for public subnets in the Egress VPC. | list(string) | n/a | **yes** |
| egress_tgw_subnets_cidr | List of CIDR blocks for TGW attachment subnets in the Egress VPC. | list(string) | n/a | **yes** |
| egress_vpc_cidr | The CIDR block for the Egress VPC. | string | n/a | **yes** |
| egress_vpc_name | The specific name for the Egress VPC. | string | "egress" | no  |
| firewall_subnets_cidr | List of CIDR blocks for Firewall/GWLB endpoint subnets in the Inspection VPC. | list(string) | n/a | **yes** |
| firewall_tools_public_subnets_cidr | List of CIDR blocks for public subnets in the Firewall Tools VPC. | list(string) | n/a | **yes** |
| firewall_tools_tgw_subnets_cidr | List of CIDR blocks for TGW attachment subnets in the Firewall Tools VPC. | list(string) | n/a | **yes** |
| firewall_tools_vpc_cidr | The CIDR block for the Firewall Tools VPC. | string | n/a | **yes** |
| firewall_type | The type of firewall to deploy ('NETWORK_FIREWALL', 'GATEWAY_LOAD_BALANCER', or 'NONE'). | string | "NONE" | no  |
| flow_log_account_id | The AWS Account ID where the central flow log S3 bucket resides. | string | null | no  |
| flow_log_s3_bucket_name | The name of the central S3 bucket to send all VPC flow logs to. | string | null | no  |
| fw_tools_vpc_name | The specific name for the Firewall Tools VPC. | string | "fw-tools" | no  |
| gwlb_name | The name for the Gateway Load Balancer. | string | "gwlb" | no  |
| ingress_public_subnets_cidr | List of CIDR blocks for public subnets in the Ingress VPC. | list(string) | n/a | **yes** |
| ingress_tgw_subnets_cidr | List of CIDR blocks for TGW attachment subnets in the Ingress VPC. | list(string) | n/a | **yes** |
| ingress_vpc_cidr | The CIDR block for the Ingress VPC. | string | n/a | **yes** |
| ingress_vpc_name | The specific name for the Ingress VPC. | string | "ingress" | no  |
| inspection_vpc_cidr | The CIDR block for the Inspection VPC. | string | n/a | **yes** |
| inspection_vpc_name | The specific name for the Inspection VPC. | string | "inspection" | no  |
| on_prem_dns_server_ip | The IP address of the on-premise DNS server. | string | null | no  |
| on_prem_domain_name | The domain name for the on-premise network. | string | "example.local" | no  |
| private_subnets_cidr | List of CIDR blocks for private subnets in the Inspection VPC. | list(string) | n/a | **yes** |
| public_subnets_cidr | List of CIDR blocks for public subnets in the Inspection VPC. | list(string) | n/a | **yes** |
| tgw_asn | The BGP ASN for the Transit Gateway. | number | 64512 | no  |
| tgw_subnets_cidr | List of CIDR blocks for TGW attachment subnets in the Inspection VPC. | list(string) | n/a | **yes** |
| workload_vpcs | A map of workload VPCs to create. Each key is a unique name for the VPC. | map(object({ ... })) | {}  | no  |

**Outputs (Root Module)**

After a successful terraform apply, the following outputs will be available:

| **Name** | **Description** |
| --- | --- |
| endpoint_public_subnets | List of public subnet IDs in the Endpoint VPC. |
| endpoint_tgw_vpc_attachment_id | The ID of the Endpoint VPC TGW attachment. |
| endpoint_vpc_id | The ID of the Endpoint VPC. |
| egress_public_subnets | List of public subnet IDs in the Egress VPC. |
| egress_tgw_vpc_attachment_id | The ID of the Egress VPC TGW attachment. |
| egress_vpc_id | The ID of the Egress VPC. |
| firewall_tools_public_subnets | List of public subnet IDs in the Firewall Tools VPC. |
| firewall_tools_tgw_vpc_attachment_id | The ID of the Firewall Tools VPC TGW attachment. |
| firewall_tools_vpc_id | The ID of the Firewall Tools VPC. |
| flow_log_bucket_arn | The ARN of the central S3 bucket for VPC flow logs. |
| gwlb_arn | The ARN of the Gateway Load Balancer. |
| ingress_public_subnets | List of public subnet IDs in the Ingress VPC. |
| After a successful terraform apply, the following outputs will be available: |     |
| ingress_tgw_vpc_attachment_id | The ID of the Ingress VPC TGW attachment. |
| ingress_vpc_id | The ID of the Ingress VPC. |
| inspection_firewall_subnets | List of Firewall/GWLB endpoint subnet IDs. |
| inspection_tgw_route_table_id | The ID of the Inspection TGW route table. |
| inspection_tgw_vpc_attachment_id | The ID of the Inspection VPC TGW attachment. |
| inspection_vpc_id | The ID of the Inspection VPC. |
| network_firewall_arn | The ARN of the AWS Network Firewall. |
| outbound_resolver_endpoint_id | The ID of the outbound Route 53 resolver endpoint. |
| spoke_tgw_route_table_id | The ID of the Spoke TGW route table. |
| tgw_id | The ID of the Transit Gateway. |
| vpn_connection_id | The ID of the Site-to-Site VPN connection. |
| workload_vpc_outputs | A map containing all outputs for each created workload VPC. |