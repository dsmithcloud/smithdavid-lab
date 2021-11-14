resource "azurerm_log_analytics_workspace" "ussc-core-log" {
  name                = "ussc-core-log"
  location            = azurerm_resource_group.ussc-law.location
  resource_group_name = azurerm_resource_group.ussc-law.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_workspace" "euw-core-log" {
  name                = "euw-core-log"
  location            = azurerm_resource_group.euw-law.location
  resource_group_name = azurerm_resource_group.euw-law.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
