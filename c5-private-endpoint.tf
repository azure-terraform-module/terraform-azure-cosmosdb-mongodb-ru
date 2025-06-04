# 4. Private DNS Zone and Link
resource "azurerm_private_dns_zone" "private_dns_cosmosdb" {
  count = local.is_private && length(var.private_dns_zone_ids) == 0 ? 1 : 0
  name  = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosdb_private_dns_zone_link" {
  count = (
    local.is_private && length(var.private_dns_zone_ids) == 0
    ? length(var.vnet_ids)
    : 0
  )
  name                  = "${var.mongodb_name}-dns-link-${basename(var.vnet_ids[count.index])}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_cosmosdb[0].name
  virtual_network_id    = var.vnet_ids[count.index]
  tags                  = var.tags
  depends_on = [
    azurerm_private_dns_zone.private_dns_cosmosdb
  ]
}

# 5. Private Endpoint with DNS Zone Group (best practice)
resource "azurerm_private_endpoint" "cosmos_private_endpoint" {
  count = local.is_private ? length(var.subnet_ids) : 0
  name                = "${var.mongodb_name}-private-endpoint-${local.subnet_info[var.subnet_ids[count.index]].name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_ids[count.index]

  private_service_connection {
    name                           = "${var.mongodb_name}-private-connection-${local.subnet_info[var.subnet_ids[count.index]].name}"
    private_connection_resource_id = azurerm_cosmosdb_account.mongo.id
    is_manual_connection           = false
    subresource_names              = ["MongoDB"]
  }

  dynamic "private_dns_zone_group" {
    for_each = local.private_dns_zone_ids != null && length(local.private_dns_zone_ids) > 0 ? [1] : []
    content {
      name                 = "default"
      private_dns_zone_ids = local.private_dns_zone_ids
    }
  }

  tags = var.tags
 
  depends_on = [
    azurerm_private_dns_zone.private_dns_cosmosdb,
    azurerm_private_dns_zone_virtual_network_link.cosmosdb_private_dns_zone_link
  ]
}