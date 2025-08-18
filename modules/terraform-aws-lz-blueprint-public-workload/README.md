# terraform-aws-lz-blueprint-public-workload
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_public_workload"></a> [public\_workload](#module\_public\_workload) | git@github.com:terasky-int/terraform-aws-vpc.git | andrey-dev |

## Resources

No resources.

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
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | A list of CIDRs for private subnets. Use the `private_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | `[]` | no |
| <a name="input_private_subnet_names"></a> [private\_subnet\_names](#input\_private\_subnet\_names) | Explicit values to use in the Name tag on private subnets. If empty, Name tags are generated | `list(string)` | `[]` | no |
| <a name="input_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#input\_public\_subnet\_cidrs) | A list of CIDRs for private subnets. Use the `private_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | `[]` | no |
| <a name="input_public_subnet_names"></a> [public\_subnet\_names](#input\_public\_subnet\_names) | Explicit values to use in the Name tag on private subnets. If empty, Name tags are generated | `list(string)` | `[]` | no |
| <a name="input_resolver_rule_id"></a> [resolver\_rule\_id](#input\_resolver\_rule\_id) | The resolver rule ID | `string` | `""` | no |
| <a name="input_route53_phz_comment"></a> [route53\_phz\_comment](#input\_route53\_phz\_comment) | Provide description for Route 53 PHZ Domain | `string` | `""` | no |
| <a name="input_route53_resolver_arn"></a> [route53\_resolver\_arn](#input\_route53\_resolver\_arn) | The Route 53 resolver ARN | `string` | `""` | no |
| <a name="input_tgw_hub_rt_id"></a> [tgw\_hub\_rt\_id](#input\_tgw\_hub\_rt\_id) | The ID of the Hub Route Table in the TGW, this is the RT that only the Inspection VPC is attached to, we need to update the route there with the our new VPC | `string` | `null` | no |
| <a name="input_tgw_route_table_id"></a> [tgw\_route\_table\_id](#input\_tgw\_route\_table\_id) | The ID of the TGW Route Table (in a single TGW RT deployment) | `string` | `null` | no |
| <a name="input_tgw_spoke_rt_id"></a> [tgw\_spoke\_rt\_id](#input\_tgw\_spoke\_rt\_id) | The ID of the Spoke Route Table in the TGW, this is the RT that all the VPCs are attached to | `string` | `null` | no |
| <a name="input_tgw_subnet_cidrs"></a> [tgw\_subnet\_cidrs](#input\_tgw\_subnet\_cidrs) | A list of CIDRs for Transit Gateway Attachment subnets. Use the `tgw_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | `[]` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The CIDR block for the Public VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | `string` | `""` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The Public VPC name | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->