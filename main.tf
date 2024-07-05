##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

################################################################################
# VPC Attachment
################################################################################

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = var.vpc_attachments

  transit_gateway_id = var.transit_gateway_id != "" ? each.value.transit_gateway_id : var.transit_gateway_id
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
