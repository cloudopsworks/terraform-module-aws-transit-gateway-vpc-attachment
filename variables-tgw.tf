##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

# VPC attachments to create against one or more Transit Gateways.
# YAML structure:
# vpc_attachments:
#   app:                                  # (Required) Logical attachment name; used in resource keys and Name tags.
#     vpc_id: "vpc-0123456789abcdef0"    # (Required) Existing VPC identifier to attach.
#     subnet_ids:                         # (Required) Existing subnet IDs from the VPC; AWS requires one subnet per Availability Zone to attach.
#       - "subnet-0123456789abcdef0"
#       - "subnet-abcdef0123456789"
#     transit_gateway_id: "tgw-0123456789abcdef0" # (Optional) Per-attachment TGW ID; required only when transit_gateway_id is not set globally. Default: null.
#     dns_support: true                   # (Optional) Enable DNS support for the attachment. Valid values: true, false. Default: true.
#     ipv6_support: false                 # (Optional) Enable IPv6 support for the attachment. Valid values: true, false. Default: false.
#     appliance_mode_support: false       # (Optional) Enable appliance mode support for stateful inspection appliances. Valid values: true, false. Default: false.
#     transit_gateway_default_route_table_association: true # (Optional) Associate with the TGW default route table. Valid values: true, false. Default: true.
#     transit_gateway_default_route_table_propagation: true # (Optional) Propagate routes to the TGW default route table. Valid values: true, false. Default: true.
#     tags:                               # (Optional) Additional tags for the attachment and its TGW ENIs. Default: {}.
#       Environment: "dev"
variable "vpc_attachments" {
  description = "Map of Transit Gateway VPC attachments keyed by logical attachment name. Each value configures the VPC, subnets, optional per-attachment TGW ID, feature flags, route table behavior, and tags."
  type = map(object({
    vpc_id                                          = string
    subnet_ids                                      = list(string)
    transit_gateway_id                              = optional(string)
    dns_support                                     = optional(bool, true)
    ipv6_support                                    = optional(bool, false)
    appliance_mode_support                          = optional(bool, false)
    transit_gateway_default_route_table_association = optional(bool, true)
    transit_gateway_default_route_table_propagation = optional(bool, true)
    tags                                            = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for name, attachment in var.vpc_attachments :
      length(trimspace(attachment.vpc_id)) > 0 && length(attachment.subnet_ids) > 0
    ])
    error_message = "Each VPC attachment must define a non-empty vpc_id and at least one subnet_id."
  }
}

# Global EC2 Transit Gateway ID used by attachments unless an attachment provides transit_gateway_id.
variable "transit_gateway_id" {
  description = "Default EC2 Transit Gateway identifier for all VPC attachments. Leave empty only when every vpc_attachments entry defines transit_gateway_id."
  type        = string
  default     = ""
}
