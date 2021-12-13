resource "azurerm_network_watcher" "netwatch-ussc" {
  name                = "netwatch-core-ussc"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "southcentralus"
  tags                = merge(local.settings.common_tags, local.settings.core_tags)
}

resource "azurerm_network_watcher" "netwatch-euw" {
  name                = "netwatch-core-euw"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "westeurope"
  tags                = merge(local.settings.common_tags, local.settings.core_tags)
}
