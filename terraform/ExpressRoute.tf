
resource "azurerm_express_route_circuit" "expressroute" {
  name                  = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.resourcelabels.expressroute}"
  resource_group_name   = azurerm_resource_group.networking.name
  location              = azurerm_resource_group.networking.location
  service_provider_name = local.settings.expressroute.service-provider
  peering_location      = local.settings.expressroute.peering-location
  bandwidth_in_mbps     = local.settings.expressroute.bandwidth
  count                 = local.settings.expressroute.enabled ? 1 : 0

  sku {
    tier   = local.settings.expressroute.tier
    family = local.settings.expressroute.family
  }

tags = local.settings.tags
}

