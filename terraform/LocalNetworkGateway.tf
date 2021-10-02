resource "azurerm_local_network_gateway" "localgateway" {
  name                = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.localnetworkgateway.location_label}-${local.settings.naming.resourcelabels.lng}"
  resource_group_name = azurerm_resource_group.networking.name
  location            = azurerm_resource_group.networking.location
  gateway_address     = local.settings.localnetworkgateway.gateway_address
  address_space       = local.settings.localnetworkgateway.address_space
  count               = local.settings.enable_localgateway ? 1 : 0
  tags                = local.settings.tags
}
