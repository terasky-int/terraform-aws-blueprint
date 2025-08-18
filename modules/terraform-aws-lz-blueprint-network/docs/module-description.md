
<!-- BEGIN_TF_DOCS -->
#
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_egress_tgw_rt"></a> [egress\_tgw\_rt](#module\_egress\_tgw\_rt) | git@gitlab.com:skywiz-io/aws_lz_hub_n_spoke.git//tgw-rt-association | n/a |
| <a name="module_egress_vpc"></a> [egress\_vpc](#module\_egress\_vpc) | git@gitlab.com:skywiz-io/aws_lz_hub_n_spoke.git//vpc | n/a |
| <a name="module_endpoint_tgw_rt"></a> [endpoint\_tgw\_rt](#module\_endpoint\_tgw\_rt) | git@gitlab.com:skywiz-io/aws_lz_hub_n_spoke.git//tgw-rt-association | n/a |
| <a name="module_endpoint_vpc"></a> [endpoint\_vpc](#module\_endpoint\_vpc) | git@gitlab.com:skywiz-io/aws_lz_hub_n_spoke.git//vpc | n/a |
| <a name="module_endpoint_vpc_update_inspection_vpc_rt_gwlb"></a> [endpoint\_vpc\_update\_inspection\_vpc\_rt\_gwlb](#module\_endpoint\_vpc\_update\_inspection\_vpc\_rt\_gwlb) | git@gitlab.com:skywiz-io/aws_lz_hub_n_spoke.git//update-inspection-rt | n/a |
| <a name="module_fw_tools_tgw_rt"></a> [fw\_tools\_tgw\_rt](#module\_fw\_tools\_tgw\_rt) | git@gitlab.com:skywiz-io/aws_lz_hub_n_spoke.git//tgw-rt-association | n/a |
| <a name="module_fw_tools_update_egress_vpc_rt"></a> [fw\_tools\_update\_egress\_vpc\_rt](#module\_fw\_tools\_update\_egress\_vpc\_rt) | git@gitlab.com:skywiz-io/aws_lz_hub_n_spoke.git//update-ingress-egress-rt | n/a |
| <a name="module_fw_tools_update_ingress_vpc_rt"></a> [fw\_tools\_update\_ingress\_vpc\_rt](#module\_fw\_tools\_update\_ingress\_vpc\_rt) | git@gitlab.com:skywiz-io/aws_lz_hub_n_spoke.git//update-ingress-egress-rt | n/a |
| <a name="module_fw_tools_update_inspection_vpc_rt"></a> [fw\_tools\_update\_inspection\_vpc\_rt](#module\_fw\_tools\_update\_inspection\_vpc\_rt) | git@gitlab.com:skywiz-io/aws_lz_hub_n_spoke.git//update-inspection-rt | n/a |
| <a name="module_fw_tools_vpc"></a> [fw\_tools\_vpc](#module\_fw\_tools\_vpc) | git@gitlab.com:skywiz-io/aws_lz_hub_n_spoke.git//vpc | n/a |
| <a name="module_gwlb"></a> [gwlb](#module\_gwlb) | git@gitlab.com:skywiz-io/aws_lz_hub_n_spoke.git//gwlb | n/a |
| <a name="module_ingress_tgw_rt"></a> [ingress\_tgw\_rt](#module\_ingress\_tgw\_rt) | git@gitlab.com:skywiz-io/aws_lz_hub_n_spoke.git//tgw-rt-association | n/a |
| <a name="module_ingress_vpc"></a> [ingress\_vpc](#module\_ingress\_vpc) | git@gitlab.com:skywiz-io/aws_lz_hub_n_spoke.git//vpc | n/a |
| <a name="module_inspection_tgw_rt"></a> [inspection\_tgw\_rt](#module\_inspection\_tgw\_rt) | git@gitlab.com:skywiz-io/aws_lz_hub_n_spoke.git//tgw-rt-association | n/a |
| <a name="module_inspection_vpc"></a> [inspection\_vpc](#module\_inspection\_vpc) | git@gitlab.com:skywiz-io/aws_lz_hub_n_spoke.git//vpc | n/a |
| <a name="module_tgw"></a> [tgw](#module\_tgw) | git@gitlab.com:skywiz-io/aws_lz_hub_n_spoke.git//tgw | n/a |
| <a name="module_update_endpoint_vpc_rt"></a> [update\_endpoint\_vpc\_rt](#module\_update\_endpoint\_vpc\_rt) | git@gitlab.com:skywiz-io/aws_lz_hub_n_spoke.git//update-vpc-rt | n/a |
| <a name="module_update_fw_tools_vpc_rt"></a> [update\_fw\_tools\_vpc\_rt](#module\_update\_fw\_tools\_vpc\_rt) | git@gitlab.com:skywiz-io/aws_lz_hub_n_spoke.git//update-vpc-rt | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_vpc_attachment.egress_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.endpoint_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.fw_tools_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.ingress_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.inspection_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | The AWS account name | `string` | n/a | yes |
| <a name="input_assume_role_name"></a> [assume\_role\_name](#input\_assume\_role\_name) | ARN of an IAM Role to assume | `string` | n/a | yes |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | AWS account ID to assume the IAM role in | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Name of the AWS region | `string` | n/a | yes |
| <a name="input_create_aws_fw"></a> [create\_aws\_fw](#input\_create\_aws\_fw) | Whether to create a AWS Network Firewall | `bool` | n/a | yes |
| <a name="input_create_fw_tools_vpc"></a> [create\_fw\_tools\_vpc](#input\_create\_fw\_tools\_vpc) | Whether to create a VPC for Firewall Tools such as FortiGate Analyzer | `bool` | n/a | yes |
| <a name="input_create_gwlb"></a> [create\_gwlb](#input\_create\_gwlb) | Whether to create a AWS Gateway Load Balancer for the Firewall | `bool` | n/a | yes |
| <a name="input_create_inspection"></a> [create\_inspection](#input\_create\_inspection) | Whether there is a Firewall in the environment | `bool` | n/a | yes |
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
| <a name="input_flow_log_destination_arn"></a> [flow\_log\_destination\_arn](#input\_flow\_log\_destination\_arn) | The ARN of the the VPC Flow Logs S3 Bucket | `string` | n/a | yes |
| <a name="input_fw_tools_private_subnet_cidrs"></a> [fw\_tools\_private\_subnet\_cidrs](#input\_fw\_tools\_private\_subnet\_cidrs) | A list of CIDRs for private subnets. Use the `private_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | `[]` | no |
| <a name="input_fw_tools_tgw_subnet_cidrs"></a> [fw\_tools\_tgw\_subnet\_cidrs](#input\_fw\_tools\_tgw\_subnet\_cidrs) | A list of CIDRs for Transit Gateway Attachment subnets. Use the `tgw_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | `[]` | no |
| <a name="input_fw_tools_vpc_cidr"></a> [fw\_tools\_vpc\_cidr](#input\_fw\_tools\_vpc\_cidr) | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | `string` | `""` | no |
| <a name="input_fw_tools_vpc_name"></a> [fw\_tools\_vpc\_name](#input\_fw\_tools\_vpc\_name) | The FW Tools VPC name | `string` | `""` | no |
| <a name="input_gwlb_name"></a> [gwlb\_name](#input\_gwlb\_name) | The name of the Gateway Load Balancer | `string` | `"GWLB"` | no |
| <a name="input_ingress_private_subnet_cidrs"></a> [ingress\_private\_subnet\_cidrs](#input\_ingress\_private\_subnet\_cidrs) | A list of CIDRs for private subnets. Use the `private_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | n/a | yes |
| <a name="input_ingress_public_subnet_cidrs"></a> [ingress\_public\_subnet\_cidrs](#input\_ingress\_public\_subnet\_cidrs) | A list of CIDRs for public subnets. Use the `public_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | n/a | yes |
| <a name="input_ingress_vpc_cidr"></a> [ingress\_vpc\_cidr](#input\_ingress\_vpc\_cidr) | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | `string` | n/a | yes |
| <a name="input_ingress_vpc_name"></a> [ingress\_vpc\_name](#input\_ingress\_vpc\_name) | The Ingress VPC name | `string` | n/a | yes |
| <a name="input_inspection_private_subnet_cidrs"></a> [inspection\_private\_subnet\_cidrs](#input\_inspection\_private\_subnet\_cidrs) | A list of CIDRs for private subnets. Use the `private_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | `[]` | no |
| <a name="input_inspection_public_subnet_cidrs"></a> [inspection\_public\_subnet\_cidrs](#input\_inspection\_public\_subnet\_cidrs) | A list of CIDRs for public subnets. Use the `public_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | `[]` | no |
| <a name="input_inspection_tgw_subnet_cidrs"></a> [inspection\_tgw\_subnet\_cidrs](#input\_inspection\_tgw\_subnet\_cidrs) | A list of CIDRs for Transit Gateway Attachment subnets. Use the `tgw_subnet_network_start` variable to dynamically calculate the network CIDRs | `list(string)` | `[]` | no |
| <a name="input_inspection_vpc_cidr"></a> [inspection\_vpc\_cidr](#input\_inspection\_vpc\_cidr) | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | `string` | `""` | no |
| <a name="input_inspection_vpc_name"></a> [inspection\_vpc\_name](#input\_inspection\_vpc\_name) | The Inspection VPC name | `string` | `"Inspection"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_egress_private_subnets"></a> [egress\_private\_subnets](#output\_egress\_private\_subnets) | List of IDs of private subnets |
| <a name="output_egress_public_subnets"></a> [egress\_public\_subnets](#output\_egress\_public\_subnets) | List of IDs of public subnets |
| <a name="output_egress_vpc_arn"></a> [egress\_vpc\_arn](#output\_egress\_vpc\_arn) | The ARN of the VPC |
| <a name="output_egress_vpc_id"></a> [egress\_vpc\_id](#output\_egress\_vpc\_id) | The ID of the VPC |
| <a name="output_endpoint_private_subnets"></a> [endpoint\_private\_subnets](#output\_endpoint\_private\_subnets) | List of IDs of private subnets |
| <a name="output_endpoint_tgw_subnets"></a> [endpoint\_tgw\_subnets](#output\_endpoint\_tgw\_subnets) | List of IDs of Transit Gateway Attachment subnets |
| <a name="output_endpoint_vpc_arn"></a> [endpoint\_vpc\_arn](#output\_endpoint\_vpc\_arn) | The ARN of the VPC |
| <a name="output_endpoint_vpc_id"></a> [endpoint\_vpc\_id](#output\_endpoint\_vpc\_id) | The ID of the VPC |
| <a name="output_fw_tools_vpc_arn"></a> [fw\_tools\_vpc\_arn](#output\_fw\_tools\_vpc\_arn) | The ARN of the VPC |
| <a name="output_fw_tools_vpc_id"></a> [fw\_tools\_vpc\_id](#output\_fw\_tools\_vpc\_id) | The ID of the VPC |
| <a name="output_fw_tools_vpc_private_subnets"></a> [fw\_tools\_vpc\_private\_subnets](#output\_fw\_tools\_vpc\_private\_subnets) | List of IDs of private subnets |
| <a name="output_fw_tools_vpc_tgw_subnets"></a> [fw\_tools\_vpc\_tgw\_subnets](#output\_fw\_tools\_vpc\_tgw\_subnets) | List of IDs of Transit Gateway Attachment subnets |
| <a name="output_gwlb_arn"></a> [gwlb\_arn](#output\_gwlb\_arn) | The ID of the Gateway Load Balancer |
| <a name="output_gwlb_id"></a> [gwlb\_id](#output\_gwlb\_id) | The ID of the Gateway Load Balancer |
| <a name="output_gwlb_vpc_endpoint_arns"></a> [gwlb\_vpc\_endpoint\_arns](#output\_gwlb\_vpc\_endpoint\_arns) | List of ARNs of the GWLB VPC Endpoint |
| <a name="output_gwlb_vpc_endpoint_ids"></a> [gwlb\_vpc\_endpoint\_ids](#output\_gwlb\_vpc\_endpoint\_ids) | List of IDs of the GWLB VPC Endpoint |
| <a name="output_gwlb_vpc_endpoint_service_arn"></a> [gwlb\_vpc\_endpoint\_service\_arn](#output\_gwlb\_vpc\_endpoint\_service\_arn) | The ARN of the Gateway Load Balancer VPC Endpoint Service |
| <a name="output_gwlb_vpc_endpoint_service_id"></a> [gwlb\_vpc\_endpoint\_service\_id](#output\_gwlb\_vpc\_endpoint\_service\_id) | The ID of the Gateway Load Balancer VPC Endpoint Service |
| <a name="output_gwlb_vpc_endpoint_service_name"></a> [gwlb\_vpc\_endpoint\_service\_name](#output\_gwlb\_vpc\_endpoint\_service\_name) | The Name of the Gateway Load Balancer VPC Endpoint Service |
| <a name="output_inspection_database_subnets"></a> [inspection\_database\_subnets](#output\_inspection\_database\_subnets) | List of IDs of database subnets |
| <a name="output_inspection_private_subnets"></a> [inspection\_private\_subnets](#output\_inspection\_private\_subnets) | List of IDs of private subnets |
| <a name="output_inspection_public_subnets"></a> [inspection\_public\_subnets](#output\_inspection\_public\_subnets) | List of IDs of public subnets |
| <a name="output_inspection_tgw_subnets"></a> [inspection\_tgw\_subnets](#output\_inspection\_tgw\_subnets) | List of IDs of Transit Gateway Attachment subnets |
| <a name="output_inspection_vpc_arn"></a> [inspection\_vpc\_arn](#output\_inspection\_vpc\_arn) | The ARN of the VPC |
| <a name="output_inspection_vpc_id"></a> [inspection\_vpc\_id](#output\_inspection\_vpc\_id) | The ID of the VPC |
| <a name="output_tgw_arn"></a> [tgw\_arn](#output\_tgw\_arn) | The ARN of the Transit Gateway |
| <a name="output_tgw_hub_route_table_arn"></a> [tgw\_hub\_route\_table\_arn](#output\_tgw\_hub\_route\_table\_arn) | The ARN of the Hub Route Table |
| <a name="output_tgw_hub_route_table_id"></a> [tgw\_hub\_route\_table\_id](#output\_tgw\_hub\_route\_table\_id) | The ID of the Hub Route Table |
| <a name="output_tgw_id"></a> [tgw\_id](#output\_tgw\_id) | The ID of the Transit Gateway |
| <a name="output_tgw_route_table_id"></a> [tgw\_route\_table\_id](#output\_tgw\_route\_table\_id) | The ID of the TGW Route Table (in a single TGW RT deployment) |
| <a name="output_tgw_spoke_route_table_arn"></a> [tgw\_spoke\_route\_table\_arn](#output\_tgw\_spoke\_route\_table\_arn) | The ARN of the Spoke Route Table |
| <a name="output_tgw_spoke_route_table_id"></a> [tgw\_spoke\_route\_table\_id](#output\_tgw\_spoke\_route\_table\_id) | The ID of the Spoke Route Table |
<!-- END_TF_DOCS -->
