resource "azurerm_cosmosdb_account" "mongo" {
    name                = var.mongodb_name
    location            = var.location
    resource_group_name = var.resource_group_name
    offer_type          = "Standard"
    kind                = "MongoDB"
    dynamic "geo_location" {
        for_each = toset(var.geo_locations)
        content {
            location          = geo_location.value
            failover_priority = index(var.geo_locations, geo_location.value)
            zone_redundant    = var.available_zones
        }
    }
    mongo_server_version = var.mongo_version
    consistency_policy {
      consistency_level       = var.consistency_level
    }
  
    capabilities {
      name = "EnableMongo"
    }

    dynamic "capacity" {
      for_each = var.total_throughput_limit != null ? [1] : []
      content {
        total_throughput_limit = var.total_throughput_limit
      }
    }
    capabilities {
      name = "EnableServerless"
    }

    dynamic "capabilities" {
    for_each = var.serverless_mode ? [1] : []
    content {
      name = "EnableServerless"
    }
  }

  public_network_access_enabled = local.public_network_access

  dynamic "virtual_network_rule" {
    for_each = local.is_service ? toset(var.subnet_ids) : []
    content {
      id                                   = virtual_network_rule.value
      ignore_missing_vnet_service_endpoint = true
    }
  }
  
}
  