##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

# Variable for VPC attachments to the Transit Gateway
# YAML structure:
#vpc_attachments:
#  <attachment_name>:
#    vpc_id: <vpc_id>
#    transit_gateway_id: <transit_gateway_id> # (optional, if not provided will use the module variable)
#    subnet_ids: [<subnet_id1>, <subnet_id2>, ...]
#    dns_support: <true|false> # (optional, default is true)
#    ipv6_support: <true|false> # (optional, default is false)
#    appliance_mode_support: <true|false> # (optional, default is false)
#    transit_gateway_default_route_table_association: <true|false> # (optional, default is true)
#    transit_gateway_default_route_table_propagation: <true|false> # (optional, default is true)
#    tags: # (optional, default is empty)
#      <tag_key>: <tag_value>
variable "vpc_attachments" {
  description = "Maps of maps of VPC details to attach to TGW. Type 'any' to disable type validation by Terraform."
  type        = any
  default     = {}
}

# Variable for EC2 Transit Gateway ID
variable "transit_gateway_id" {
  description = "EC2 Transit Gateway identifier"
  type        = string
  default     = ""
}