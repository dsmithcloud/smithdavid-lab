resource "azurerm_public_ip" "firewallpip1" {
  name                = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.resourcelabels.azfirewall}-${local.settings.naming.resourcelabels.publicip}"
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
  allocation_method   = local.settings.azurefirewall.pip_allocation
  sku                 = local.settings.azurefirewall.pip_sku
  #public_ip_prefix_id = azurerm_public_ip_prefix.hub-pip-prefix[0].id
  count               = local.settings.enable_azfirewall ? 1 : 0
  tags                = local.settings.tags
}

resource "azurerm_firewall" "firewall" {
  name                = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.resourcelabels.azfirewall}"
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
  count               = local.settings.enable_azfirewall ? 1 : 0
  tags                = local.settings.tags

  ip_configuration {
    name                 = "ipconfig1"
    subnet_id            = azurerm_subnet.firewallsubnet[0].id
    public_ip_address_id = azurerm_public_ip.firewallpip1[0].id
  }
}
