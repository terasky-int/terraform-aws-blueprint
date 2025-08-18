
- [Terraform Modifications](#terraform-modifications)
  - [Mandatory Values](#mandatory-values)
  - [Optional Values](#optional-values)
  - [Global Values](#global-values)
    - [TGW Values](#tgw-values)
  - [VPC Values](#vpc-values)
    - [Ingress VPC](#ingress-vpc)
    - [Egress VPC](#egress-vpc)
    - [FW tools VPC](#fw-tools-vpc)
    - [Inspection VPC](#inspection-vpc)
    - [Endpoint VPC](#endpoint-vpc)
    - [AWS Network Firewall](#aws-network-firewall)
    - [AWS VPN CLient](#aws-vpn-client)

# Terraform Modifications
## Mandatory Values
## Optional Values

## Global Values
```bash
environment = "" # Required, 
account_name = "" # Required, 
create_inspection = # Required, 

```
### TGW Values
```bash

```
## VPC Values
### Ingress VPC
```bash
ingress_vpc_name = ""  # Required
ingress_vpc_cidr = ""  # Required
ingress_private_subnet_cidrs = ""  # Required
ingress_public_subnet_cidrs = ""  # Required
enable_flow_log = "" # Required
flow_log_destination_arn = "" # Required
```
### Egress VPC
```bash
egress_vpc_name = "" # Required, Default is "Egress"
egress_vpc_cidr = "" # Required
egress_private_subnet_cidrs = "" # Required
egress_public_subnet_cidrs = "" # Required
enable_flow_log = "" # Required
flow_log_destination_arn = "" # Required
```
### FW tools VPC
```bash
fw_tools_vpc_name = "" # Required
fw_tools_vpc_cidr = "" # Required
fw_tools_tgw_subnet_cidrs = "" # Required
fw_tools_private_subnet_cidrs = "" # Required
enable_flow_log = "" # Required
flow_log_destination_arn = "" # Required
```

### Inspection VPC
```bash
inspection_vpc_name = "" # Required, Default is "Inspection"
inspection_vpc_cidr = "" # Required
firewall_subnet_cidrs = "" # Required
inspection_public_subnet_cidrs = "" # Required
inspection_tgw_subnet_cidrs = "" # Required
inspection_private_subnet_cidrs = "" # Required
enable_flow_log = "" # Required
flow_log_destination_arn = "" # Required
```
### Endpoint VPC
```bash
endpoint_vpc_cidr = "" # Required
endpoint_tgw_subnet_cidrs = "" # Required
endpoint_private_subnet_cidrs = "" # Required
enable_flow_log =  "" # Required
flow_log_destination_arn =  "" # Required
```

### AWS Network Firewall
```bash
anfw_name = "" # Optional
anfw_policy_name = "" # Optional, Default is "anfw-policy"

TBD
```
### AWS VPN CLient
```bash
vpn_client_organization_name_certificate = "" # Optional
vpn_client_name = "" # Optional
vpn_client_authentication_type = # Optional, Default is "certificate-authentication"
vpn_client_cidr = "" # Optional, Default is "10.10.0.0/22"
vpn_client_logs_retention = 365 # Optional, Default is 365
vpn_client_split_tunnel = true # Optional, Default is 'true'
vpn_client_port = 1194 # Optional, Default is 1194
```

