variable "endpoint_slice_v1s" {
  description = <<EOT
Map of endpoint_slice_v1s, attributes below
Required:
    - address_type
    - endpoint (block):
        - addresses (required)
        - condition (optional, block):
            - ready (optional)
            - serving (optional)
            - terminating (optional)
        - hostname (optional)
        - node_name (optional)
        - target_ref (optional, block):
            - field_path (optional)
            - name (required)
            - namespace (optional)
            - resource_version (optional)
            - uid (optional)
        - zone (optional)
    - metadata (block):
        - annotations (optional)
        - generate_name (optional)
        - labels (optional)
        - name (optional)
        - namespace (optional)
    - port (block):
        - app_protocol (required)
        - name (optional)
        - port (required)
        - protocol (optional)
EOT

  type = map(object({
    address_type = string
    endpoint = list(object({
      addresses = list(string)
      condition = optional(object({
        ready       = optional(bool)
        serving     = optional(bool)
        terminating = optional(bool)
      }))
      hostname  = optional(string)
      node_name = optional(string)
      target_ref = optional(object({
        field_path       = optional(string)
        name             = string
        namespace        = optional(string)
        resource_version = optional(string)
        uid              = optional(string)
      }))
      zone = optional(string)
    }))
    metadata = object({
      annotations   = optional(map(string))
      generate_name = optional(string)
      labels        = optional(map(string))
      name          = optional(string)
      namespace     = optional(string)
    })
    port = list(object({
      app_protocol = string
      name         = optional(string)
      port         = string
      protocol     = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.endpoint_slice_v1s : (
        length(v.endpoint) >= 1 && length(v.endpoint) <= 1000
      )
    ])
    error_message = "Each endpoint list must contain between 1 and 1000 items"
  }
  validation {
    condition = alltrue([
      for k, v in var.endpoint_slice_v1s : (
        length(v.port) >= 1 && length(v.port) <= 100
      )
    ])
    error_message = "Each port list must contain between 1 and 100 items"
  }
  validation {
    condition = alltrue([
      for k, v in var.endpoint_slice_v1s : (
        contains(["IPv4", "IPv6", "FQDN"], v.address_type)
      )
    ])
    error_message = "must be one of: \"IPv4\", \"IPv6\", \"FQDN\""
  }
  # Note: 1 additional provider-side validator is enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

