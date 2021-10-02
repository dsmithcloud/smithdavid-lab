resource "azurerm_virtual_wan" "vwan" {
  name                = "euw-core-vwan1"
  resource_group_name = azurerm_resource_group.rg-vwan.name
  location            = azurerm_resource_group.rg-vwan.location
}