resource "azurerm_application_security_group" "adds-asg" {
  name                = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.resourcelabels.adds}-${local.settings.naming.resourcelabels.asg}"
  location            = azurerm_resource_group.ADDS.location
  resource_group_name = azurerm_resource_group.ADDS.name
  count               = local.settings.adds_dccount >= 1 ? 1 : 0
  tags                = local.settings.tags
}

resource "azurerm_network_interface_application_security_group_association" "adds-asg-assoc" {
  network_interface_id          = element(azurerm_network_interface.adds_nic.*.id, count.index)
  application_security_group_id = azurerm_application_security_group.adds-asg[0].id
  count                         = local.settings.adds_dccount >= 1 ? local.settings.adds.dccount : 0
}