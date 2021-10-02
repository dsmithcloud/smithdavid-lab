# This will be the UDR to direct traffic to the Azure Firewall
# This route tables settings are defined in the Azure Firewall section of the settings file
resource "azurerm_route_table" "firewallroutetable" {
  name                          = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.resourcelabels.azfirewall}-${local.settings.naming.resourcelabels.routetable}"
  location                      = azurerm_resource_group.networking.location
  resource_group_name           = azurerm_resource_group.networking.name
  disable_bgp_route_propagation = false
  count                         = local.settings.azurefirewall.routetable.enabled ? 1 : 0

  route {
    name                   = local.settings.azurefirewall.routetable.route_name
    address_prefix         = local.settings.azurefirewall.routetable.route_address_prefix
    next_hop_type          = local.settings.azurefirewall.routetable.route_next_hop_type
    next_hop_in_ip_address = azurerm_firewall.firewall[0].ip_configuration[0].private_ip_address
  }
tags = local.settings.tags
}

resource "azurerm_subnet_route_table_association" "firewallroutetable_addsassoc" {
  subnet_id      = azurerm_subnet.addssubnet[0].id
  route_table_id = azurerm_route_table.firewallroutetable[0].id
  count          = local.settings.azurefirewall.routetable.subnetassociations.adds ? 1 : 0
}

# Other route tables, add as needed
/*
resource "azurerm_route_table" "routetable2" {
  name                          = local.settings.networking.routetable2.name
  location                      = azurerm_resource_group.networking.location
  resource_group_name           = azurerm_resource_group.networking.name
  disable_bgp_route_propagation = false

  route {
    name           = local.settings.networking.routetable2.route_name
    address_prefix = local.settings.networking.routetable2.route_address_prefix
    next_hop_type  = local.settings.networking.routetable2.route_next_hop_type
  }

tags = local.settings.tags
}

resource "azurerm_subnet_route_table_association" "association2" {
  subnet_id      = azurerm_subnet.firewallsubnet[0].id
  route_table_id = azurerm_route_table.routetable2.id
}

*/