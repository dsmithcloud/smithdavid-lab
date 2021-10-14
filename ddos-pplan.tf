# resource "azurerm_network_ddos_protection_plan" "ddos-plan" {
#   name                = "ddospplan1"
#   resource_group_name = azurerm_resource_group.rg-network.name
#   location            = azurerm_resource_group.rg-network.location
# }