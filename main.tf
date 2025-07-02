##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

################################################################################
# VPC Attachment
################################################################################

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = var.vpc_attachments

  transit_gateway_id = var.transit_gateway_id != "" ? var.transit_gateway_id : each.value.transit_gateway_id
  vpc_id             = each.value.vpc_id
  subnet_ids         = each.value.subnet_ids

  dns_support                                     = try(each.value.dns_support, true) ? "enable" : "disable"
  ipv6_support                                    = try(each.value.ipv6_support, false) ? "enable" : "disable"
  appliance_mode_support                          = try(each.value.appliance_mode_support, false) ? "enable" : "disable"
  transit_gateway_default_route_table_association = try(each.value.transit_gateway_default_route_table_association, true)
  transit_gateway_default_route_table_propagation = try(each.value.transit_gateway_default_route_table_propagation, true)

  tags = merge(
    local.all_tags,
    {
      Name = format("tgw-att-%s", each.key)
    },
    try(each.value.tags, {}),
  )
}

data "aws_network_interfaces" "this" {
  for_each = merge([
    for att_name, attachment in var.vpc_attachments : {
      for sub in attachment.subnet_ids : "${att_name}-${sub}" => {
        att_name  = att_name
        subnet_id = sub
      }
    }
  ]...)

  filter {
    name   = "interface-type"
    values = ["transit_gateway"]
  }

  filter {
    name   = "subnet-id"
    values = [each.value.subnet_id]
  }
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.this]
}

resource "aws_ec2_tag" "tgw_att_eni" {
  for_each = merge(flatten([
    for att_name, attachment in var.vpc_attachments : [
      for sub in attachment.subnet_ids : {
        for k, v in local.all_tags : "${att_name}-${sub}-${k}" => {
          att_name  = att_name
          subnet_id = sub
          tag_key   = k
          tag_value = v
        }
      }
    ]
  ])...)
  resource_id = data.aws_network_interfaces.this[format("%s-%s", each.value.att_name, each.value.subnet_id)].ids[0]
  key         = each.value.tag_key
  value       = each.value.tag_value
}