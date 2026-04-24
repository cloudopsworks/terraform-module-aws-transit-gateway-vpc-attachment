## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_tag.tgw_att_eni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_network_interfaces.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_interfaces) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Establish this is a HUB or spoke configuration | `bool` | `false` | no |
| <a name="input_org"></a> [org](#input\_org) | n/a | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | n/a | `string` | `"001"` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | Default EC2 Transit Gateway identifier for all VPC attachments. Leave empty only when every vpc\_attachments entry defines transit\_gateway\_id. | `string` | `""` | no |
| <a name="input_vpc_attachments"></a> [vpc\_attachments](#input\_vpc\_attachments) | Map of Transit Gateway VPC attachments keyed by logical attachment name. Each value configures the VPC, subnets, optional per-attachment TGW ID, feature flags, route table behavior, and tags. | <pre>map(object({<br/>    vpc_id                                          = string<br/>    subnet_ids                                      = list(string)<br/>    transit_gateway_id                              = optional(string)<br/>    dns_support                                     = optional(bool, true)<br/>    ipv6_support                                    = optional(bool, false)<br/>    appliance_mode_support                          = optional(bool, false)<br/>    transit_gateway_default_route_table_association = optional(bool, true)<br/>    transit_gateway_default_route_table_propagation = optional(bool, true)<br/>    tags                                            = optional(map(string), {})<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_transit_gateway_attachment_ids"></a> [transit\_gateway\_attachment\_ids](#output\_transit\_gateway\_attachment\_ids) | Transit Gateway VPC attachment IDs keyed by attachment name. |
| <a name="output_transit_gateway_attachments"></a> [transit\_gateway\_attachments](#output\_transit\_gateway\_attachments) | Transit Gateway VPC attachment details. Preserves the legacy list shape for backward compatibility. |
