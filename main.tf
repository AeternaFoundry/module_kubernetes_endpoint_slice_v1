resource "kubernetes_endpoint_slice_v1" "endpoint_slice_v1s" {
  for_each = var.endpoint_slice_v1s

  address_type = each.value.address_type

  dynamic "endpoint" {
    for_each = each.value.endpoint
    content {
      addresses = endpoint.value.addresses
      dynamic "condition" {
        for_each = endpoint.value.condition != null ? [endpoint.value.condition] : []
        content {
          ready       = condition.value.ready
          serving     = condition.value.serving
          terminating = condition.value.terminating
        }
      }
      hostname  = endpoint.value.hostname
      node_name = endpoint.value.node_name
      dynamic "target_ref" {
        for_each = endpoint.value.target_ref != null ? [endpoint.value.target_ref] : []
        content {
          field_path       = target_ref.value.field_path
          name             = target_ref.value.name
          namespace        = target_ref.value.namespace
          resource_version = target_ref.value.resource_version
          uid              = target_ref.value.uid
        }
      }
      zone = endpoint.value.zone
    }
  }

  metadata {
    annotations   = each.value.metadata.annotations
    generate_name = each.value.metadata.generate_name
    labels        = each.value.metadata.labels
    name          = each.value.metadata.name
    namespace     = each.value.metadata.namespace
  }

  dynamic "port" {
    for_each = each.value.port
    content {
      app_protocol = port.value.app_protocol
      name         = port.value.name
      port         = port.value.port
      protocol     = port.value.protocol
    }
  }
}

