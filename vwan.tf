resource "azurerm_virtual_wan" "vwan" {
  name                = "euw-core-vwan1"
  resource_group_name = azurerm_resource_group.rg-vwan.name
  location            = azurerm_resource_group.rg-vwan.location
  disable_vpn_encryption = false
  allow_branch_to_branch_traffic = true
  type = "Standard"
  tags = "${merge(local.settings.common_tags, local.settings.core_tags)}"

}

resource "azurerm_virtual_hub" "vwan-hub1" {
  name = "euw-core-vwan1-hub"
  resource_group_name = azurerm_resource_group.rg-vwan.name
  location = "westeurope"
  virtual_wan_id = azurerm_virtual_wan.vwan.id
  address_prefix = "172.16.1.0/24"
}

resource "azurerm_virtual_hub" "vwan-hub2" {
  name = "ussc-core-vwan1-hub"
  resource_group_name = azurerm_resource_group.rg-vwan.name
  location = "southcentralus"
  virtual_wan_id = azurerm_virtual_wan.vwan.id
  address_prefix = "172.16.2.0/24"
}