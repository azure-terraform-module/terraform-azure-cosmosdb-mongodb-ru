resource "azurerm_cosmosdb_account" "mongo" {
    name                = "example-mongo-cosmos"
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
  
}
  