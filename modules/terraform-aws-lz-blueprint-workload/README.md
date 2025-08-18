# Terraform-AWS-LZ-Blueprint-Workload
This TF module creates a workload vpc with the respective routing to Hub &amp; Spoke model
- [Terraform-AWS-LZ-Blueprint-Workload](#terraform-aws-lz-blueprint-workload)
- [Getting Started](#getting-started)
  - [GitHub Actions](#github-actions)
  - [How to Enable / Disable](#how-to-enable--disable)
    - [AWS Landing Zone with Ingress and Egress VPCs](#aws-landing-zone-with-ingress-and-egress-vpcs)
      - [Required Inputs](#required-inputs)
    - [K8S with AWS Network FW based Hub \& spoke RT model with Ingress and Inspection VPCs](#k8s-with-aws-network-fw-based-hub--spoke-rt-model-with-ingress-and-inspection-vpcs)
      - [Required Inputs](#required-inputs-1)
    - [Ingress with Inspection VPC \& AWS Network Firewall](#ingress-with-inspection-vpc--aws-network-firewall)
      - [Required Inputs](#required-inputs-2)
    - [Ingress with Inspection VPC \& Custom Firewall](#ingress-with-inspection-vpc--custom-firewall)
      - [Required Inputs](#required-inputs-3)
    - [PREKS Ingress with Inspection VPC \& AWS Network Firewall](#preks-ingress-with-inspection-vpc--aws-network-firewall)
      - [Enable/Disable](#enabledisable)
      - [Required Inputs](#required-inputs-4)
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

## How to Enable / Disable
In the Terraform values, we packaged components into an aspect package. In order to enable / disable aspects, Please edit your TFC variables according to this list:
### AWS Landing Zone with Ingress and Egress VPCs
[Architecture Design](https://lucid.app/lucidchart/155f121c-ccf6-42b4-ad99-a2db4495aeb5/edit?page=4YCWH0LbebbdR#)
```hcl
create_central_dns = true
create_egress_routing = true
create_gwlb_routing = false
create_ingress_routing = true
create_inspection = false
create_inspection_routing = false
enable_flow_log = true/false # Depend on your needs
```
#### Required Inputs
```hcl
account_name = ""
aws_region = ""
aws_account = "" 
assume_role_name = ""
environment = ""
tgw_route_table_id = ""
endpoint_vpc_cidr = ""
ingress_vpc_cidr = ""
k8s_aws_account = ""
private_subnet_cidrs = []
tgw_subnet_cidrs = []
vpc_cidr = ""
vpc_name = ""
```


### K8S with AWS Network FW based Hub & spoke RT model with Ingress and Inspection VPCs 
[Architecture Design](https://lucid.app/lucidchart/48dbc739-02e9-42c9-980a-188e9411d13d/edit?page=cXDSOCXoO6AwS&invitationId=inv_8521be29-bef9-4725-a968-f115056fcea9#)
```hcl
TBD
```
#### Required Inputs
```hcl
TBD
```

### Ingress with Inspection VPC & AWS Network Firewall
[Architecture Design](https://lucid.app/lucidchart/90dfa8c6-42f1-4e11-8751-f838d590d1bd/edit?page=cXDSOCXoO6AwS&invitationId=inv_0e296800-bf06-4dbc-b0f1-2bfd246a89d9#)
```hcl
create_central_dns = false
create_egress_routing = false
create_gwlb_routing = false
create_ingress_routing = true
create_inspection = true
create_inspection_routing = false
enable_flow_log = true/false # Depend on your needs
```

#### Required Inputs
```hcl
account_name = ""
aws_region = ""
aws_account = "" 
assume_role_name = ""
environment = ""
tgw_route_table_id = ""
tgw_spoke_rt_id = ""
endpoint_vpc_cidr = ""
ingress_vpc_cidr = ""
k8s_aws_account = ""
private_subnet_cidrs = []
tgw_subnet_cidrs = []
vpc_cidr = ""
vpc_name = ""
```
### Ingress with Inspection VPC & Custom Firewall
[Architecture Design](https://lucid.app/lucidchart/90dfa8c6-42f1-4e11-8751-f838d590d1bd/edit?page=cXDSOCXoO6AwS&invitationId=inv_0e296800-bf06-4dbc-b0f1-2bfd246a89d9#)
```hcl
create_central_dns = false
create_egress_routing = false
create_gwlb_routing = true
create_ingress_routing = true
create_inspection = true
create_inspection_routing = false
enable_flow_log = true/false # Depend on your needs
```

#### Required Inputs
```hcl
account_name = ""
aws_region = ""
aws_account = "" 
assume_role_name = ""
environment = ""
tgw_route_table_id = ""
tgw_spoke_rt_id = ""
endpoint_vpc_cidr = ""
ingress_vpc_cidr = ""
private_subnet_cidrs = []
tgw_subnet_cidrs = []
vpc_cidr = ""
vpc_name = ""
```
### PREKS Ingress with Inspection VPC & AWS Network Firewall 
#### Enable/Disable
```hcl
```

#### Required Inputs
```hcl
```


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.43.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tgw_association"></a> [tgw\_association](#module\_tgw\_association) | git@github.com:terasky-int/terraform-aws-tgw-rt-association.git | v1.0 |
| <a name="module_update_inspection_vpc_rt"></a> [update\_inspection\_vpc\_rt](#module\_update\_inspection\_vpc\_rt) | git@github.com:terasky-int/terraform-aws-update-inspection-rts.git | v1.0 |
| <a name="module_workload_private"></a> [workload\_private](#module\_workload\_private) | git@github.com:terasky-int/terraform-aws-vpc.git | andrey-dev |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_vpc_attachment.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_route.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.private_subnets_all_to_tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.tgw_subnets_all_to_tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_ec2_transit_gateway.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_transit_gateway) | data source |
| [aws_route_table.inspection_pub_rt_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_route_table.inspection_pub_rt_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_route_tables.egress_rts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_route_tables.ingress_rts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_route_tables.inspection_private_rts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_vpc.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.endpoint_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.inspection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc_endpoint.fw-endpoint-a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint) | data source |
| [aws_vpc_endpoint.fw-endpoint-b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | The AWS account name | `string` | n/a | yes |
| <a name="input_assume_role_name"></a> [assume\_role\_name](#input\_assume\_role\_name) | ARN of an IAM Role to assume | `string` | `"TerraformExecutionRole"` | no |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | AWS account ID to assume the IAM role in | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Name of the AWS region | `string` | n/a | yes |
| <a name="input_create_central_dns"></a> [create\_central\_dns](#input\_create\_central\_dns) | Whether to create central hybrid dns management | `bool` | n/a | yes |
| <a name="input_create_egress_routing"></a> [create\_egress\_routing](#input\_create\_egress\_routing) | True to update Egress VPC (Private and Public) RTs with the Workload VPC CIDR Block, in order to access the internet | `bool` | n/a | yes |
| <a name="input_create_gwlb_routing"></a> [create\_gwlb\_routing](#input\_create\_gwlb\_routing) | Whether there is a AWS Gateway Load Balancer for the Custom Firewall in the environment | `bool` | n/a | yes |
| <a name="input_create_ingress_routing"></a> [create\_ingress\_routing](#input\_create\_ingress\_routing) | Whether the Workload VPC you created supposed to have routing from the internet | `bool` | n/a | yes |
| <a name="input_create_inspection_routing"></a> [create\_inspection\_routing](#input\_create\_inspection\_routing) | Whether there is a Custom Firewall (3th Party Vendor) in the environment | `bool` | n/a | yes |
| <a name="input_egress_vpc_cidr"></a> [egress\_vpc\_cidr](#input\_egress\_vpc\_cidr) | The CIDR block for the Egress VPC in the Network account | `string` | `""` | no |
| <a name="input_enable_flow_log"></a> [enable\_flow\_log](#input\_enable\_flow\_log) | Whether or not to enable VPC Flow Logs | `bool` | n/a | yes |
| <a name="input_endpoint_vpc_cidr"></a> [endpoint\_vpc\_cidr](#input\_endpoint\_vpc\_cidr) | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment this resource is part of. Valid values include `dev`, `test`, `poc`, `prod`, `shared-services` | `string` | n/a | yes |
| <a name="input_flow_log_destination_arn"></a> [flow\_log\_destination\_arn](#input\_flow\_log\_destination\_arn) | The ARN of the the VPC Flow Logs S3 Bucket | `string` | `""` | no |
| <a name="input_ingress_vpc_cidr"></a> [ingress\_vpc\_cidr](#input\_ingress\_vpc\_cidr) | The CIDR block for the Ingress VPC in the Network account | `string` | `""` | no |
| <a name="input_inspection_vpc_cidr"></a> [inspection\_vpc\_cidr](#input\_inspection\_vpc\_cidr) | The CIDR block for the Inspection VPC in the Network account. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | `string` | `""` | no |
| <a name="input_private_domain_name"></a> [private\_domain\_name](#input\_private\_domain\_name) | Provide private domain name that created on network account | `string` | `""` | no |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | A list of CIDRs for private subnets. Use the `private_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | n/a | yes |
| <a name="input_private_subnet_names"></a> [private\_subnet\_names](#input\_private\_subnet\_names) | Explicit values to use in the Name tag on private subnets. If empty, Name tags are generated | `list(string)` | `[]` | no |
| <a name="input_private_subnet_suffix"></a> [private\_subnet\_suffix](#input\_private\_subnet\_suffix) | Suffix to append to private subnets name | `string` | `"private"` | no |
| <a name="input_public_vpc_cidr"></a> [public\_vpc\_cidr](#input\_public\_vpc\_cidr) | The CIDR block for the Public VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | `string` | `""` | no |
| <a name="input_public_vpc_name"></a> [public\_vpc\_name](#input\_public\_vpc\_name) | The Public VPC name | `string` | `""` | no |
| <a name="input_public_vpc_private_subnet_cidrs"></a> [public\_vpc\_private\_subnet\_cidrs](#input\_public\_vpc\_private\_subnet\_cidrs) | A list of CIDRs for private subnets. Use the `private_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | `[]` | no |
| <a name="input_public_vpc_private_subnet_names"></a> [public\_vpc\_private\_subnet\_names](#input\_public\_vpc\_private\_subnet\_names) | Explicit values to use in the Name tag on private subnets. If empty, Name tags are generated | `list(string)` | `[]` | no |
| <a name="input_public_vpc_public_subnet_cidrs"></a> [public\_vpc\_public\_subnet\_cidrs](#input\_public\_vpc\_public\_subnet\_cidrs) | A list of CIDRs for private subnets. Use the `private_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | `[]` | no |
| <a name="input_public_vpc_public_subnet_names"></a> [public\_vpc\_public\_subnet\_names](#input\_public\_vpc\_public\_subnet\_names) | Explicit values to use in the Name tag on private subnets. If empty, Name tags are generated | `list(string)` | `[]` | no |
| <a name="input_public_vpc_tgw_subnet_cidrs"></a> [public\_vpc\_tgw\_subnet\_cidrs](#input\_public\_vpc\_tgw\_subnet\_cidrs) | A list of CIDRs for Transit Gateway Attachment subnets. Use the `tgw_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | `[]` | no |
| <a name="input_resolver_rule_id"></a> [resolver\_rule\_id](#input\_resolver\_rule\_id) | The resolver rule ID | `string` | `""` | no |
| <a name="input_route53_phz_comment"></a> [route53\_phz\_comment](#input\_route53\_phz\_comment) | Provide description for Route 53 PHZ Domain | `string` | `""` | no |
| <a name="input_route53_resolver_arn"></a> [route53\_resolver\_arn](#input\_route53\_resolver\_arn) | The Route 53 resolver ARN | `string` | `""` | no |
| <a name="input_tgw_hub_rt_id"></a> [tgw\_hub\_rt\_id](#input\_tgw\_hub\_rt\_id) | The ID of the Hub Route Table in the TGW, this is the RT that only the Inspection VPC is attached to, we need to update the route there with the our new VPC | `string` | `null` | no |
| <a name="input_tgw_route_table_id"></a> [tgw\_route\_table\_id](#input\_tgw\_route\_table\_id) | The ID of the TGW Route Table (in a single TGW RT deployment) | `string` | `null` | no |
| <a name="input_tgw_spoke_rt_id"></a> [tgw\_spoke\_rt\_id](#input\_tgw\_spoke\_rt\_id) | The ID of the Spoke Route Table in the TGW, this is the RT that all the VPCs are attached to | `string` | `null` | no |
| <a name="input_tgw_subnet_cidrs"></a> [tgw\_subnet\_cidrs](#input\_tgw\_subnet\_cidrs) | A list of CIDRs for Transit Gateway Attachment subnets. Use the `tgw_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | `[]` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The VPC name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_subnets"></a> [database\_subnets](#output\_database\_subnets) | List of IDs of database subnets |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of private subnets |
| <a name="output_tgw_subnets"></a> [tgw\_subnets](#output\_tgw\_subnets) | List of IDs of Transit Gateway Attachment subnets |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | The ARN of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->