##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

output "transit_gateway_attachments" {
  description = "Transit Gateway VPC attachment details. Preserves the legacy list shape for backward compatibility."
  value = [
    for attachment in aws_ec2_transit_gateway_vpc_attachment.this : {
      id                 = attachment.id
      vpc_id             = attachment.vpc_id
      transit_gateway_id = attachment.transit_gateway_id
    }
  ]
}

output "transit_gateway_attachment_ids" {
  description = "Transit Gateway VPC attachment IDs keyed by attachment name."
  value = {
    for name, attachment in aws_ec2_transit_gateway_vpc_attachment.this : name => attachment.id
  }
}
