# Terraform-AWS-LZ-Blueprint-Network
This TF module creates the resources for the Network account in the AWS LZ Hub &amp; Spoke model. That includes the Ingress, Egress, Endpoint VPCs; with an option for Inspection VPC with a FW (AWS NFW or Vendor FW with GWLB)

- [Terraform-AWS-LZ-Blueprint-Network](#terraform-aws-lz-blueprint-network)
- [Getting Started](#getting-started)
  - [GitHub Actions](#github-actions)
    - [TBD](#tbd)
  - [How to Enable / Disable](#how-to-enable--disable)
  - [AWS Landing Zone with Ingress and Egress VPCs](#aws-landing-zone-with-ingress-and-egress-vpcs)
      - [Required Inputs](#required-inputs)
  - [Ingress and Inspection VPCs with Custom Firewall](#ingress-and-inspection-vpcs-with-custom-firewall)
      - [Required Inputs](#required-inputs-1)
    - [Ingress and Inspection VPC with AWS Network Firewall](#ingress-and-inspection-vpc-with-aws-network-firewall)
      - [Required Inputs](#required-inputs-2)
  - [K8S with AWS Network FW based Hub \& spoke RT model with Ingress and Inspection VPCs](#k8s-with-aws-network-fw-based-hub--spoke-rt-model-with-ingress-and-inspection-vpcs)
      - [Required Inputs](#required-inputs-3)
  - [Setup Remote State Backend for Terraform](#setup-remote-state-backend-for-terraform)
  - [Terraform Modifications](#terraform-modifications)
  - [Requirements](#requirements)
  - [Providers](#providers)
  - [Modules](#modules)
  - [Resources](#resources)
  - [Inputs](#inputs)
  - [Outputs](#outputs)

# Getting Started

## GitHub Actions
To skip run workflows you need include into commit the one of the next options:
```bash
[skip ci]
[ci skip]
[no ci]
[skip actions]
[actions skip]
```
### TBD
1. Add cleanup resources to workflows.

## How to Enable / Disable 
In the Terraform values, we packaged components into an aspect package.
In order to enable / disable aspects, Please edit your TFC variables according to this list:

## AWS Landing Zone with Ingress and Egress VPCs
[Architecture Design](https://lucid.app/lucidchart/155f121c-ccf6-42b4-ad99-a2db4495aeb5/edit?viewport_loc=-4062%2C-4428%2C3311%2C1670%2C4YCWH0LbebbdR&invitationId=inv_305b5a50-6fdf-4461-9293-5cfd6b93e3c0)

```HCL
create_aws_fw = false
create_central_dns = false
create_fw_tools_vpc = false
create_gwlb = false
create_inspection = false
create_vpn_client = true/false # Depends on your needs
enable_flow_log = true/false # Depends on your needs
```
#### Required Inputs
```hcl
account_name = ""
aws_account = ""
aws_account_log_archived = ""
aws_region = ""
egress_private_subnet_cidrs = [""]
egress_public_subnet_cidrs = [""]
egress_vpc_cidr = ""
endpoint_private_subnet_cidrs = [""]
endpoint_tgw_subnet_cidrs = [""]
endpoint_vpc_cidr = ""
environment = ""
ingress_private_subnet_cidrs = [""]
ingress_public_subnet_cidrs = [""]
ingress_vpc_cidr = ""
ingress_vpc_name = ""
```
## Ingress and Inspection VPCs with Custom Firewall
[Architecture Design](https://lucid.app/lucidchart/ffeeb6b4-1ecc-4b3a-9931-b0bfa3577686/edit?viewport_loc=-4412%2C-6361%2C2361%2C1336%2CcXDSOCXoO6AwS&invitationId=inv_d7c721ff-563b-410c-b3db-0e595e14340f)
```hcl
create_aws_fw = false
create_phz = true/false # Depends on you need central private hosted zone in Network Account
create_aws_vpn_gateway = false
create_central_dns = false
create_fw_tools_vpc = false
create_gwlb = true
create_inspection = true 
create_vpn_client = true/false # Depends on your needs
enable_flow_log = true/false # Depends on your needs
```
#### Required Inputs
```hcl
account_name = ""
aws_account = ""
aws_account_log_archived = ""
aws_region = ""
endpoint_private_subnet_cidrs = [""]
endpoint_tgw_subnet_cidrs = [""]
endpoint_vpc_cidr = ""
environment = ""
firewall_subnet_cidrs = [""]
ingress_private_subnet_cidrs = [""]
ingress_public_subnet_cidrs = [""]
ingress_vpc_cidr = ""
ingress_vpc_name = ""
inspection_private_subnet_cidrs = [""]
inspection_public_subnet_cidrs = [""]
inspection_tgw_subnet_cidrs = [""]
inspection_vpc_cidr = ""
```

### Ingress and Inspection VPC with AWS Network Firewall
[Architecture Design](https://lucid.app/lucidchart/90dfa8c6-42f1-4e11-8751-f838d590d1bd/edit?page=cXDSOCXoO6AwS&invitationId=inv_0e296800-bf06-4dbc-b0f1-2bfd246a89d9#)
```hcl
create_aws_fw = false
create_aws_vpn_gateway = true/false # Dependss on your needs
create_central_dns = false
create_fw_tools_vpc = false
create_gwlb = false
create_inspection = true 
create_fw_tools_vpc = false
create_vpn_client = true/false # Depends on your needs
enable_flow_log = true/false # Depends on your needs
```
#### Required Inputs
```hcl
account_name = ""
aws_account = ""
aws_account_log_archived = ""
aws_region = ""
endpoint_private_subnet_cidrs = [""]
endpoint_tgw_subnet_cidrs = [""]
endpoint_vpc_cidr = ""
environment = ""
firewall_subnet_cidrs = [""]
ingress_private_subnet_cidrs = [""]
ingress_public_subnet_cidrs = [""]
ingress_vpc_cidr = ""
ingress_vpc_name = ""
inspection_private_subnet_cidrs = [""]
inspection_public_subnet_cidrs = [""]
inspection_tgw_subnet_cidrs = [""]
inspection_vpc_cidr = ""
```

## K8S with AWS Network FW based Hub & spoke RT model with Ingress and Inspection VPCs
[Architecture Design](https://lucid.app/lucidchart/542692ef-4d96-4185-8853-4395a7bcd2a3/edit?viewport_loc=-5506%2C-6197%2C4109%2C2072%2CcXDSOCXoO6AwS&invitationId=inv_5223268a-553c-4893-be13-8f8b4df70674)

In this use case k8s vpc created in workload account with route 53 privated hosted zone.
```hcl
TBD
```

#### Required Inputs
```hcl
TBD
```

## Setup Remote State Backend for Terraform
Configure remote state with Terraform Cloud (TFC):
```hcl
terraform {
    cloud {
    organization = "<Your Organization>"
    workspaces {
      name = "<Your Workspace Name>"
    }
  }
}
```
## Terraform Modifications
To enable or disable aspects, modify Terraform Cloud (TFC) variables based on the following list:
Module description can be found at [Module Description](./docs/module-description.md)

Examples of how to modify the implementation can be found at [terraform modifications](./docs/terraform-modification.md)
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.42.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_egress_tgw_rt"></a> [egress\_tgw\_rt](#module\_egress\_tgw\_rt) | git@github.com:terasky-int/terraform-aws-tgw-rt-association.git | v1.0 |
| <a name="module_egress_vpc"></a> [egress\_vpc](#module\_egress\_vpc) | git@github.com:terasky-int/terraform-aws-vpc.git | andrey-dev |
| <a name="module_endpoint_tgw_rt"></a> [endpoint\_tgw\_rt](#module\_endpoint\_tgw\_rt) | git@github.com:terasky-int/terraform-aws-tgw-rt-association.git | v1.0 |
| <a name="module_endpoint_vpc"></a> [endpoint\_vpc](#module\_endpoint\_vpc) | git@github.com:terasky-int/terraform-aws-vpc.git | andrey-dev |
| <a name="module_endpoint_vpc_update_inspection_vpc_rt_aws_fw"></a> [endpoint\_vpc\_update\_inspection\_vpc\_rt\_aws\_fw](#module\_endpoint\_vpc\_update\_inspection\_vpc\_rt\_aws\_fw) | git@github.com:terasky-int/terraform-aws-update-inspection-rts.git | v1.0 |
| <a name="module_endpoint_vpc_update_inspection_vpc_rt_gwlb"></a> [endpoint\_vpc\_update\_inspection\_vpc\_rt\_gwlb](#module\_endpoint\_vpc\_update\_inspection\_vpc\_rt\_gwlb) | git@github.com:terasky-int/terraform-aws-update-inspection-rts.git | v1.0 |
| <a name="module_fw_tools_tgw_rt"></a> [fw\_tools\_tgw\_rt](#module\_fw\_tools\_tgw\_rt) | git@github.com:terasky-int/terraform-aws-tgw-rt-association.git | v1.0 |
| <a name="module_fw_tools_update_egress_vpc_rt"></a> [fw\_tools\_update\_egress\_vpc\_rt](#module\_fw\_tools\_update\_egress\_vpc\_rt) | git@github.com:terasky-int/terraform-aws-lz-update-rt.git//update-ingress-egress-rt | n/a |
| <a name="module_fw_tools_update_ingress_vpc_rt"></a> [fw\_tools\_update\_ingress\_vpc\_rt](#module\_fw\_tools\_update\_ingress\_vpc\_rt) | git@github.com:terasky-int/terraform-aws-lz-update-rt.git//update-ingress-egress-rt | n/a |
| <a name="module_fw_tools_update_inspection_vpc_rt"></a> [fw\_tools\_update\_inspection\_vpc\_rt](#module\_fw\_tools\_update\_inspection\_vpc\_rt) | git@github.com:terasky-int/terraform-aws-update-inspection-rts.git | v1.0 |
| <a name="module_fw_tools_vpc"></a> [fw\_tools\_vpc](#module\_fw\_tools\_vpc) | git@github.com:terasky-int/terraform-aws-vpc.git | andrey-dev |
| <a name="module_gwlb"></a> [gwlb](#module\_gwlb) | git@github.com:terasky-int/terraform-aws-gwlb.git | v1.0 |
| <a name="module_hybrid_private_dns"></a> [hybrid\_private\_dns](#module\_hybrid\_private\_dns) | git@github.com:terasky-int/terraform-aws-lz-hybrid-centralized-dns-management.git | v1.1 |
| <a name="module_ingress_tgw_rt"></a> [ingress\_tgw\_rt](#module\_ingress\_tgw\_rt) | git@github.com:terasky-int/terraform-aws-tgw-rt-association.git | v1.0 |
| <a name="module_ingress_vpc"></a> [ingress\_vpc](#module\_ingress\_vpc) | git@github.com:terasky-int/terraform-aws-vpc.git | andrey-dev |
| <a name="module_inspection_tgw_rt"></a> [inspection\_tgw\_rt](#module\_inspection\_tgw\_rt) | git@github.com:terasky-int/terraform-aws-tgw-rt-association.git | v1.0 |
| <a name="module_inspection_vpc"></a> [inspection\_vpc](#module\_inspection\_vpc) | git@github.com:terasky-int/terraform-aws-network-firewall-vpc.git//vpc | n/a |
| <a name="module_network_firewall"></a> [network\_firewall](#module\_network\_firewall) | git@github.com:terasky-int/terraform-aws-network-firewall.git | n/a |
| <a name="module_s3_logs_network_firewall"></a> [s3\_logs\_network\_firewall](#module\_s3\_logs\_network\_firewall) | terraform-aws-modules/s3-bucket/aws | 3.8.2 |
| <a name="module_sg_route_resolver"></a> [sg\_route\_resolver](#module\_sg\_route\_resolver) | terraform-aws-modules/security-group/aws | 5.1.0 |
| <a name="module_tgw"></a> [tgw](#module\_tgw) | git@github.com:terasky-int/terraform-aws-tgw.git | v1.1 |
| <a name="module_vpn"></a> [vpn](#module\_vpn) | git@github.com:terasky-int/terraform-aws-lz-vpn-s2s.git | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_vpc_attachment.egress_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.endpoint_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.fw_tools_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.ingress_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.inspection_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_route.endpoint_all_to_tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.fw_tools_all_to_tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.fw_tools_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.fw_tools_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | The AWS account name | `string` | n/a | yes |
| <a name="input_additional_vpc"></a> [additional\_vpc](#input\_additional\_vpc) | A list of maps representing additional the VPCs to associate with the Route 53 zone | <pre>list(object({<br>    vpc_id     = string<br>    vpc_region = string<br>  }))</pre> | `[]` | no |
| <a name="input_allow_additional_cidr_blocks"></a> [allow\_additional\_cidr\_blocks](#input\_allow\_additional\_cidr\_blocks) | Provide additional cidr blocks to allow in security groups | `list(string)` | `[]` | no |
| <a name="input_anfw_name"></a> [anfw\_name](#input\_anfw\_name) | Name for AWS Network Firewall | `string` | `"network-firewall"` | no |
| <a name="input_anfw_policy_name"></a> [anfw\_policy\_name](#input\_anfw\_policy\_name) | The Policy Name for Network Firewall | `string` | `"Policy-test"` | no |
| <a name="input_assume_role_name"></a> [assume\_role\_name](#input\_assume\_role\_name) | ARN of an IAM Role to assume | `string` | `"TerraformExecutionRole"` | no |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | AWS account ID to assume the IAM role in | `string` | n/a | yes |
| <a name="input_aws_account_log_archived"></a> [aws\_account\_log\_archived](#input\_aws\_account\_log\_archived) | AWS account ID to assume the IAM role in | `string` | `""` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Name of the AWS region | `string` | n/a | yes |
| <a name="input_create_aws_fw"></a> [create\_aws\_fw](#input\_create\_aws\_fw) | Whether to create a AWS Network Firewall | `bool` | `null` | no |
| <a name="input_create_aws_vpn_gateway"></a> [create\_aws\_vpn\_gateway](#input\_create\_aws\_vpn\_gateway) | True if you want cretae VPN Gateway | `bool` | `null` | no |
| <a name="input_create_central_dns"></a> [create\_central\_dns](#input\_create\_central\_dns) | Whether to create central hybrid dns management | `bool` | `null` | no |
| <a name="input_create_fw_tools_vpc"></a> [create\_fw\_tools\_vpc](#input\_create\_fw\_tools\_vpc) | Whether to create a VPC for Firewall Tools such as FortiGate Analyzer | `bool` | n/a | yes |
| <a name="input_create_gwlb"></a> [create\_gwlb](#input\_create\_gwlb) | Whether to create a AWS Gateway Load Balancer for the Firewall | `bool` | n/a | yes |
| <a name="input_create_inspection"></a> [create\_inspection](#input\_create\_inspection) | Whether there is a Firewall in the environment | `bool` | n/a | yes |
| <a name="input_create_netwrok_firewall"></a> [create\_netwrok\_firewall](#input\_create\_netwrok\_firewall) | This enable or deisable Network firewall: The default is false | `bool` | `null` | no |
| <a name="input_create_phz"></a> [create\_phz](#input\_create\_phz) | Whether to create central PHZ | `bool` | `null` | no |
| <a name="input_domain_stateful_rule_group"></a> [domain\_stateful\_rule\_group](#input\_domain\_stateful\_rule\_group) | "Config for domain type stateful rule group"<br>domain\_stateful\_rule\_group = [<br>  {<br>      capacity    = 100<br>      name        = "DOMAINSFEXAMPLE1"<br>      description = "Stateful rule example1 with domain list option"<br>      domain\_list = ["test.example.com", "test1.example.com"]<br>      actions     = "DENYLIST"<br>      protocols   = ["HTTP\_HOST", "TLS\_SNI"]<br>      rule\_variables = {<br>          ip\_sets = [{<br>              key    = "WEBSERVERS\_HOSTS"<br>              ip\_set = ["10.0.0.0/16", "10.0.1.0/24", "192.168.0.0/16"]<br>          },<br>          {<br>              key    = "EXTERNAL\_HOST"<br>              ip\_set = ["0.0.0.0/0"]<br>          }]<br>          port\_sets = [<br>          {<br>              key       = "HTTP\_PORTS"<br>              port\_sets = ["443", "80"]<br>          }]<br>      }<br>  }] | `any` | `[]` | no |
| <a name="input_egress_private_subnet_cidrs"></a> [egress\_private\_subnet\_cidrs](#input\_egress\_private\_subnet\_cidrs) | A list of CIDRs for public subnets. Use the `public_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | `[]` | no |
| <a name="input_egress_public_subnet_cidrs"></a> [egress\_public\_subnet\_cidrs](#input\_egress\_public\_subnet\_cidrs) | A list of CIDRs for public subnets. Use the `public_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | `[]` | no |
| <a name="input_egress_vpc_cidr"></a> [egress\_vpc\_cidr](#input\_egress\_vpc\_cidr) | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | `string` | `""` | no |
| <a name="input_egress_vpc_name"></a> [egress\_vpc\_name](#input\_egress\_vpc\_name) | The Egress VPC name | `string` | `"Egress"` | no |
| <a name="input_enable_flow_log"></a> [enable\_flow\_log](#input\_enable\_flow\_log) | Whether or not to enable VPC Flow Logs | `bool` | n/a | yes |
| <a name="input_endpoint_private_subnet_cidrs"></a> [endpoint\_private\_subnet\_cidrs](#input\_endpoint\_private\_subnet\_cidrs) | A list of CIDRs for private subnets. Use the `private_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | n/a | yes |
| <a name="input_endpoint_tgw_subnet_cidrs"></a> [endpoint\_tgw\_subnet\_cidrs](#input\_endpoint\_tgw\_subnet\_cidrs) | A list of CIDRs for Transit Gateway Attachment subnets. Use the `tgw_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | n/a | yes |
| <a name="input_endpoint_vpc_cidr"></a> [endpoint\_vpc\_cidr](#input\_endpoint\_vpc\_cidr) | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | `string` | n/a | yes |
| <a name="input_endpoint_vpc_name"></a> [endpoint\_vpc\_name](#input\_endpoint\_vpc\_name) | The Endpoint VPC name | `string` | `"Endpoint"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment this resource is part of. Valid values include `dev`, `test`, `poc`, `prod`, `shared-services` | `string` | n/a | yes |
| <a name="input_firewall_subnet_cidrs"></a> [firewall\_subnet\_cidrs](#input\_firewall\_subnet\_cidrs) | List of CIDRs for firewall subnets. | `list(string)` | `[]` | no |
| <a name="input_fivetuple_stateful_rule_group"></a> [fivetuple\_stateful\_rule\_group](#input\_fivetuple\_stateful\_rule\_group) | "Config for 5-tuple type stateful rule group"<br>fivetuple\_stateful\_rule\_group = [<br>      {<br>      capacity    = 100<br>      name        = "stateful"<br>      description = "Stateful rule example1 with 5 tuple option"<br>      rule\_config = [{<br>          description           = "Pass All Rule"<br>          protocol              = "TCP"<br>          source\_ipaddress      = "1.2.3.4/32"<br>          source\_port           = 443<br>          destination\_ipaddress = "124.1.1.5/32"<br>          destination\_port      = 443<br>          direction             = "any"<br>          sid                   = 1<br>          actions = {<br>          type = "pass"<br>          }<br>      }]<br>      },<br>  ] | `any` | `[]` | no |
| <a name="input_fw_tools_private_subnet_cidrs"></a> [fw\_tools\_private\_subnet\_cidrs](#input\_fw\_tools\_private\_subnet\_cidrs) | A list of CIDRs for private subnets. Use the `private_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | `[]` | no |
| <a name="input_fw_tools_tgw_subnet_cidrs"></a> [fw\_tools\_tgw\_subnet\_cidrs](#input\_fw\_tools\_tgw\_subnet\_cidrs) | A list of CIDRs for Transit Gateway Attachment subnets. Use the `tgw_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | `[]` | no |
| <a name="input_fw_tools_vpc_cidr"></a> [fw\_tools\_vpc\_cidr](#input\_fw\_tools\_vpc\_cidr) | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | `string` | `""` | no |
| <a name="input_fw_tools_vpc_name"></a> [fw\_tools\_vpc\_name](#input\_fw\_tools\_vpc\_name) | The FW Tools VPC name | `string` | `""` | no |
| <a name="input_gwlb_name"></a> [gwlb\_name](#input\_gwlb\_name) | The name of the Gateway Load Balancer | `string` | `"GWLB"` | no |
| <a name="input_inbound_endpoint_direction"></a> [inbound\_endpoint\_direction](#input\_inbound\_endpoint\_direction) | (required) The direction of DNS queries to or from the Route 53 Resolver endpoint. Valid values are INBOUND (resolver forwards DNS queries to the DNS service for a VPC from your network or another VPC) or OUTBOUND (resolver forwards DNS queries from the DNS service for a VPC to your network or another VPC). | `string` | `"INBOUND"` | no |
| <a name="input_inbound_endpoint_name"></a> [inbound\_endpoint\_name](#input\_inbound\_endpoint\_name) | (optional) The friendly name of the Route 53 Resolver endpoint. | `string` | `"InboundEndpoint"` | no |
| <a name="input_ingress_private_subnet_cidrs"></a> [ingress\_private\_subnet\_cidrs](#input\_ingress\_private\_subnet\_cidrs) | A list of CIDRs for private subnets. Use the `private_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | n/a | yes |
| <a name="input_ingress_public_subnet_cidrs"></a> [ingress\_public\_subnet\_cidrs](#input\_ingress\_public\_subnet\_cidrs) | A list of CIDRs for public subnets. Use the `public_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | `[]` | no |
| <a name="input_ingress_vpc_cidr"></a> [ingress\_vpc\_cidr](#input\_ingress\_vpc\_cidr) | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | `string` | n/a | yes |
| <a name="input_ingress_vpc_name"></a> [ingress\_vpc\_name](#input\_ingress\_vpc\_name) | The Ingress VPC name | `string` | n/a | yes |
| <a name="input_inspection_private_subnet_cidrs"></a> [inspection\_private\_subnet\_cidrs](#input\_inspection\_private\_subnet\_cidrs) | A list of CIDRs for private subnets. Use the `private_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | `[]` | no |
| <a name="input_inspection_public_subnet_cidrs"></a> [inspection\_public\_subnet\_cidrs](#input\_inspection\_public\_subnet\_cidrs) | A list of CIDRs for public subnets. Use the `public_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | `[]` | no |
| <a name="input_inspection_tgw_subnet_cidrs"></a> [inspection\_tgw\_subnet\_cidrs](#input\_inspection\_tgw\_subnet\_cidrs) | A list of CIDRs for Transit Gateway Attachment subnets. Use the `tgw_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | `[]` | no |
| <a name="input_inspection_vpc_cidr"></a> [inspection\_vpc\_cidr](#input\_inspection\_vpc\_cidr) | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | `string` | `""` | no |
| <a name="input_inspection_vpc_name"></a> [inspection\_vpc\_name](#input\_inspection\_vpc\_name) | The Inspection VPC name | `string` | `"Inspection"` | no |
| <a name="input_outbound_endpoint_direction"></a> [outbound\_endpoint\_direction](#input\_outbound\_endpoint\_direction) | (required) The direction of DNS queries to or from the Route 53 Resolver endpoint. Valid values are INBOUND (resolver forwards DNS queries to the DNS service for a VPC from your network or another VPC) or OUTBOUND (resolver forwards DNS queries from the DNS service for a VPC to your network or another VPC). | `string` | `"OUTBOUND"` | no |
| <a name="input_outbound_endpoint_name"></a> [outbound\_endpoint\_name](#input\_outbound\_endpoint\_name) | (optional) The friendly name of the Route 53 Resolver endpoint. | `string` | `"OutboundEndpoint"` | no |
| <a name="input_private_zone_comment"></a> [private\_zone\_comment](#input\_private\_zone\_comment) | The description for the hosted zone. Defaults to 'Managed by Terraform' | `string` | `"Private domain on AWS for EC2 instance to resolve from custom network - Managed By Terraform"` | no |
| <a name="input_private_zone_domain_name"></a> [private\_zone\_domain\_name](#input\_private\_zone\_domain\_name) | The domain name of the hosted zone | `string` | `""` | no |
| <a name="input_provided_preshared_key1"></a> [provided\_preshared\_key1](#input\_provided\_preshared\_key1) | Provided preshared key for tunnel 1 | `string` | `""` | no |
| <a name="input_provided_preshared_key2"></a> [provided\_preshared\_key2](#input\_provided\_preshared\_key2) | Provided preshared key for tunnel 2 | `string` | `""` | no |
| <a name="input_resolver_rules"></a> [resolver\_rules](#input\_resolver\_rules) | A list of maps, where each map defines a resolver rule | <pre>list(object({<br>    resolver_rule_custom_domain_name = string<br>    resolver_rule_name               = string<br>    resolver_rule_type               = string<br>    target_ip                        = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Central S3 for all network logs usch as vpc flow logs, aws network firewall logs and etc | `string` | `""` | no |
| <a name="input_stateless_rule_group"></a> [stateless\_rule\_group](#input\_stateless\_rule\_group) | "Config for stateless rule group"<br>  stateless\_rule\_group = [<br>      {<br>      capacity    = 100<br>      name        = "stateless"<br>      description = "Stateless rule example1"<br>      rule\_config = [{<br>          priority              = 1<br>          protocols\_number      = [6]<br>          source\_ipaddress      = "1.2.3.4/32"<br>          source\_from\_port      = 443<br>          source\_to\_port        = 443<br>          destination\_ipaddress = "124.1.1.5/32"<br>          destination\_from\_port = 443<br>          destination\_to\_port   = 443<br>          tcp\_flag = {<br>          flags = ["SYN"]<br>          masks = ["SYN", "ACK"]<br>          }<br>          actions = {<br>          type = "pass"<br>          }<br>      }]<br>      }] | `any` | `[]` | no |
| <a name="input_suricata_stateful_rule_group"></a> [suricata\_stateful\_rule\_group](#input\_suricata\_stateful\_rule\_group) | "Config for Suricata type stateful rule group"<br>suricata\_stateful\_rule\_group = [<br>  {<br>      capacity    = 100<br>      name        = "SURICTASFEXAMPLE1"<br>      description = "Stateful rule example1 with suricta type"<br>      rules\_file  = "./example.rules"<br>  }] | `any` | `[]` | no |
| <a name="input_vpn_gateways"></a> [vpn\_gateways](#input\_vpn\_gateways) | "VPN Gateways for S2S, you can create multiple s2s endpoinds as you need with copy block for another s2s connection"<br>Examples:<br>  # {<br>  #   tunnel1\_preshared\_key    = ""<br>  #   tunnel1\_inside\_cidr      = "169.254.94.252/30"<br>  #   tunnel2\_preshared\_key    = ""<br>  #   tunnel2\_inside\_cidr      = "169.254.93.168/30"<br>  #   bgp\_asn                  = 64600<br>  #   destination\_ip\_address   = "1.1.1.1"<br>  #   cgw\_name                 = "test1"<br>  #   private\_destination\_cidr = "10.200.0.0/16"<br>  #   s2s\_routing              = true<br>  # },<br>  # {<br>  #   tunnel1\_preshared\_key    = ""<br>  #   tunnel1\_inside\_cidr      = "169.254.153.120/30"<br>  #   tunnel2\_preshared\_key    = ""<br>  #   tunnel2\_inside\_cidr      = "169.254.62.216/30"<br>  #   bgp\_asn                  = 64601<br>  #   destination\_ip\_address   = "2.2.2.2"<br>  #   cgw\_name                 = "test2"<br>  #   private\_destination\_cidr = "10.100.0.0/16"<br>  #   s2s\_routing              = false<br>  # }, | `any` | `[]` | no |
| <a name="input_vpn_type"></a> [vpn\_type](#input\_vpn\_type) | The type of connection | `string` | `"ipsec.1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_firewall_arn"></a> [aws\_firewall\_arn](#output\_aws\_firewall\_arn) | ARN of Network Firewall |
| <a name="output_aws_firewall_id"></a> [aws\_firewall\_id](#output\_aws\_firewall\_id) | The ID of AWS Netwrok Firewall |
| <a name="output_egress_private_subnets"></a> [egress\_private\_subnets](#output\_egress\_private\_subnets) | List of IDs of private subnets |
| <a name="output_egress_public_subnets"></a> [egress\_public\_subnets](#output\_egress\_public\_subnets) | List of IDs of public subnets |
| <a name="output_egress_vpc_arn"></a> [egress\_vpc\_arn](#output\_egress\_vpc\_arn) | The ARN of the VPC |
| <a name="output_egress_vpc_id"></a> [egress\_vpc\_id](#output\_egress\_vpc\_id) | The ID of the VPC |
| <a name="output_endpoint_private_subnets"></a> [endpoint\_private\_subnets](#output\_endpoint\_private\_subnets) | List of IDs of private subnets |
| <a name="output_endpoint_tgw_subnets"></a> [endpoint\_tgw\_subnets](#output\_endpoint\_tgw\_subnets) | List of IDs of Transit Gateway Attachment subnets |
| <a name="output_endpoint_vpc_arn"></a> [endpoint\_vpc\_arn](#output\_endpoint\_vpc\_arn) | The ARN of the VPC |
| <a name="output_endpoint_vpc_id"></a> [endpoint\_vpc\_id](#output\_endpoint\_vpc\_id) | The ID of the VPC |
| <a name="output_firewall_endpoint_ids"></a> [firewall\_endpoint\_ids](#output\_firewall\_endpoint\_ids) | ListIDs of firewall endppoinds |
| <a name="output_fw_tools_vpc_arn"></a> [fw\_tools\_vpc\_arn](#output\_fw\_tools\_vpc\_arn) | The ARN of the VPC |
| <a name="output_fw_tools_vpc_id"></a> [fw\_tools\_vpc\_id](#output\_fw\_tools\_vpc\_id) | The ID of the VPC |
| <a name="output_fw_tools_vpc_private_subnets"></a> [fw\_tools\_vpc\_private\_subnets](#output\_fw\_tools\_vpc\_private\_subnets) | List of IDs of private subnets |
| <a name="output_fw_tools_vpc_tgw_subnets"></a> [fw\_tools\_vpc\_tgw\_subnets](#output\_fw\_tools\_vpc\_tgw\_subnets) | List of IDs of Transit Gateway Attachment subnets |
| <a name="output_generated_tunnel1_presharedkey1"></a> [generated\_tunnel1\_presharedkey1](#output\_generated\_tunnel1\_presharedkey1) | Generated password for tunnel preshared key 1 |
| <a name="output_generated_tunnel2_presharedkey2"></a> [generated\_tunnel2\_presharedkey2](#output\_generated\_tunnel2\_presharedkey2) | Generated password for tunnel preshared key 2 |
| <a name="output_inspection_database_subnets"></a> [inspection\_database\_subnets](#output\_inspection\_database\_subnets) | List of IDs of database subnets |
| <a name="output_inspection_private_subnets"></a> [inspection\_private\_subnets](#output\_inspection\_private\_subnets) | List of IDs of private subnets |
| <a name="output_inspection_public_subnets"></a> [inspection\_public\_subnets](#output\_inspection\_public\_subnets) | List of IDs of public subnets |
| <a name="output_inspection_tgw_subnets"></a> [inspection\_tgw\_subnets](#output\_inspection\_tgw\_subnets) | List of IDs of Transit Gateway Attachment subnets |
| <a name="output_inspection_vpc_arn"></a> [inspection\_vpc\_arn](#output\_inspection\_vpc\_arn) | The ARN of the VPC |
| <a name="output_inspection_vpc_id"></a> [inspection\_vpc\_id](#output\_inspection\_vpc\_id) | The ID of the VPC |
| <a name="output_preshared_key1"></a> [preshared\_key1](#output\_preshared\_key1) | Provided tunnel preshared key 1 |
| <a name="output_preshared_key2"></a> [preshared\_key2](#output\_preshared\_key2) | Provided tunnel preshared key 2 |
| <a name="output_resolver_rule_id"></a> [resolver\_rule\_id](#output\_resolver\_rule\_id) | The ID of Route 53 Resolver Rules |
| <a name="output_route53_inbound_endpoint_id"></a> [route53\_inbound\_endpoint\_id](#output\_route53\_inbound\_endpoint\_id) | The ARN of the Route 53 Resolver endpoint. |
| <a name="output_route53_inbound_endpoint_ip_addresses"></a> [route53\_inbound\_endpoint\_ip\_addresses](#output\_route53\_inbound\_endpoint\_ip\_addresses) | IP addresses in your VPC that you want DNS queries to pass through on the way from your VPCs to your network (for outbound endpoints) or on the way from your network to your VPCs (for inbound endpoints) |
| <a name="output_route53_outbound_endpoint_id"></a> [route53\_outbound\_endpoint\_id](#output\_route53\_outbound\_endpoint\_id) | The ARN of the Route 53 Resolver endpoint. |
| <a name="output_route53_outbound_endpoint_ip_addresses"></a> [route53\_outbound\_endpoint\_ip\_addresses](#output\_route53\_outbound\_endpoint\_ip\_addresses) | IP addresses in your VPC that you want DNS queries to pass through on the way from your VPCs to your network (for outbound endpoints) or on the way from your network to your VPCs (for inbound endpoints) |
| <a name="output_route53_resolver_rule_arn"></a> [route53\_resolver\_rule\_arn](#output\_route53\_resolver\_rule\_arn) | The ARN of Route53 Resolver Rules that have created |
| <a name="output_s3_log_archived_arn"></a> [s3\_log\_archived\_arn](#output\_s3\_log\_archived\_arn) | The ARN of centralized S3 bucket logs |
| <a name="output_tgw_arn"></a> [tgw\_arn](#output\_tgw\_arn) | The ARN of the Transit Gateway |
| <a name="output_tgw_hub_route_table_arn"></a> [tgw\_hub\_route\_table\_arn](#output\_tgw\_hub\_route\_table\_arn) | The ARN of the Hub Route Table |
| <a name="output_tgw_hub_route_table_id"></a> [tgw\_hub\_route\_table\_id](#output\_tgw\_hub\_route\_table\_id) | The ID of the Hub Route Table |
| <a name="output_tgw_id"></a> [tgw\_id](#output\_tgw\_id) | The ID of the Transit Gateway |
| <a name="output_tgw_route_table_id"></a> [tgw\_route\_table\_id](#output\_tgw\_route\_table\_id) | The ID of the TGW Route Table (in a single TGW RT deployment) |
| <a name="output_tgw_spoke_route_table_arn"></a> [tgw\_spoke\_route\_table\_arn](#output\_tgw\_spoke\_route\_table\_arn) | The ARN of the Spoke Route Table |
| <a name="output_tgw_spoke_route_table_id"></a> [tgw\_spoke\_route\_table\_id](#output\_tgw\_spoke\_route\_table\_id) | The ID of the Spoke Route Table |
<!-- END_TF_DOCS -->