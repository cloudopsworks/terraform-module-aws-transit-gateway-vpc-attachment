locals {
  local_vars  = yamldecode(file("./inputs.yaml"))
  spoke_vars  = yamldecode(file(find_in_parent_folders("spoke-inputs.yaml")))
  region_vars = yamldecode(file(find_in_parent_folders("region-inputs.yaml")))
  env_vars    = yamldecode(file(find_in_parent_folders("env-inputs.yaml")))
  global_vars = yamldecode(file(find_in_parent_folders("global-inputs.yaml")))

  local_tags  = jsondecode(file("./local-tags.json"))
  spoke_tags  = jsondecode(file(find_in_parent_folders("spoke-tags.json")))
  region_tags = jsondecode(file(find_in_parent_folders("region-tags.json")))
  env_tags    = jsondecode(file(find_in_parent_folders("env-tags.json")))
  global_tags = jsondecode(file(find_in_parent_folders("global-tags.json")))

  tags = merge(
    local.global_tags,
    local.env_tags,
    local.region_tags,
    local.spoke_tags,
    local.local_tags
  )
}

include "root" {
  path = find_in_parent_folders("{{ .RootFileName }}")
}
{{ if .vpc_enabled }}
dependency "vpc" {
  config_path = "{{ .vpc_path }}"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "destroy"]
  mock_outputs = {
    vpc_id            = "vpc-12345678901234"
    flowlogs_role_arn = "arn:aws:iam::123456789012:role/flowlogs-role"
    private_subnets = [
      "subnet-01234567890123456",
      "subnet-01234567890123457",
      "subnet-01234567890123458",
    ]
    intra_subnets = [
      "subnet-01234567890123456",
      "subnet-01234567890123457",
      "subnet-01234567890123458",
    ]
  }
}
{{ end }}
{{ if .tgw_enabled }}
dependency "tgw" {
  config_path = "{{ .tgw_path }}"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "destroy"]
  mock_outputs = {
    transit_gateway_arn                                         = "arn:aws:ec2:us-west-2:551110472991:transit-gateway/tgw-12345678901234",
    transit_gateway_id                                          = "tgw-12345678901234"
  }
}
{{ end }}
terraform {
  source = "{{ .sourceUrl }}"
}

inputs = {
  is_hub     = {{ .is_hub }}
  org        = local.env_vars.org
  spoke_def  = local.spoke_vars.spoke
  {{- range .requiredVariables }}
  {{- if ne .Name "org" }}
  {{ .Name }} = local.local_vars.{{ .Name }}
  {{- end }}
  {{- end }}
  {{- range .optionalVariables }}
  {{- if not (eq .Name "extra_tags" "is_hub" "spoke_def" "org") }}
  {{- if and $.vpc_enabled (eq .Name "vpc_attachments") }}
  vpc_attachments = {
    (dependency.vpc.outputs.vpc_name) = {
      vpc_id     = dependency.vpc.outputs.vpc_id
      subnet_ids = dependency.vpc.outputs.{{ $.vpc_subnets }}_subnets
      dns_support = try(local.local_vars.dns_support, true)
      ipv6_support = try(local.local_vars.ipv6_support, false)
      appliance_mode_support = try(local.local_vars.appliance_mode_support, false)
      transit_gateway_default_route_table_association = try(local.local_vars.transit_gateway_default_route_table_association, true)
      transit_gateway_default_route_table_propagation = try(local.local_vars.transit_gateway_default_route_table_propagation, true)
      tags = try(local.local_vars.tags, {})
    }
  }
  {{- else if and $.tgw_enabled (eq .Name "transit_gateway_id") }}
  {{ .Name }} = dependency.tgw.outputs.transit_gateway_id
  {{- else }}
  {{ .Name }} = try(local.local_vars.{{ .Name }}, {{ .DefaultValue }})
  {{- end }}
  {{- end }}
  {{- end }}
  extra_tags = local.tags
}