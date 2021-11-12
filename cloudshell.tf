#================    Cloud Shell Subnet    ================
resource "azurerm_subnet" "subnet-ussc-core-cloudshell" {
    name           = "subnet-ussc-core-vnet1-cloudshell-10.0.0.96_28"
    address_prefixes = ["10.0.0.96/28"]
    resource_group_name = azurerm_resource_group.rg-network.name
    virtual_network_name = azurerm_virtual_network.vnet-core-ussc.name
    service_endpoints    = ["Microsoft.Storage"]
    delegation {
        name = "delegation"
        service_delegation {name = "Microsoft.ContainerInstance/containerGroups"}
    }
}

resource "azurerm_subnet" "subnet-ussc-core-relay" {
    name           = "subnet-ussc-core-vnet1-relay-10.0.0.112_28"
    address_prefixes = ["10.0.0.112/28"]
    resource_group_name = azurerm_resource_group.rg-network.name
    virtual_network_name = azurerm_virtual_network.vnet-core-ussc.name
    enforce_private_link_endpoint_network_policies = false
    enforce_private_link_service_network_policies = true
}

#================    Network Profile    ================
resource "azurerm_network_profile" "vnet-core-ussc-networkprofile" {
  name                = "vnet-core-ussc-networkprofile"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "southcentralus"
  container_network_interface {
    name = "eth-cloudshell"
    ip_configuration {
      name      = "ipconfig"
      subnet_id = azurerm_subnet.subnet-ussc-core-cloudshell.id
    }
  }
  tags = "${merge(local.settings.common_tags, local.settings.dev_tags)}"
}

#================    Relay Namespace   ================
resource "azurerm_relay_namespace" "ussc-namespace" {
  name                = "relay-core-ussc-namespace" # must be unique
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "southcentralus"
  sku_name = "Standard"
  tags = "${merge(local.settings.common_tags, local.settings.dev_tags)}"
}

#================    Role Assignments    ================
resource "azurerm_role_assignment" "ussc-role-assignment-network" {
  name = uuid()
  scope                = azurerm_network_profile.vnet-core-ussc-networkprofile.id
  role_definition_name = "Network Contributor"
  principal_id         = "c4ed4578-a9a5-494a-9551-65c018594082"
}

resource "azurerm_role_assignment" "ussc-role-assignment-contributor" {
  name = uuid()
  scope                = azurerm_network_profile.vnet-core-ussc-networkprofile.id
  role_definition_name = "Contributor"
  principal_id         = "c4ed4578-a9a5-494a-9551-65c018594082"
}

#================    Private Endpoints    ================
resource "azurerm_private_endpoint" "ussc-private-endpoint" {
  name                = "ussc-private-endpoint"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "southcentralus"
  subnet_id           = azurerm_subnet.subnet-ussc-core-relay.id
  private_service_connection {
    name                           = "ussc-privateserviceconnection"
    private_connection_resource_id = azurerm_relay_namespace.ussc-namespace.id
    is_manual_connection           = false
    subresource_names = null
  }
  tags = "${merge(local.settings.common_tags, local.settings.dev_tags)}"
}

#================    Private DNS    ================
resource "azurerm_private_dns_zone" "global-private-dns-zone" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = azurerm_resource_group.rg-network.name
  tags = "${merge(local.settings.common_tags, local.settings.dev_tags)}"
}

resource "azurerm_private_dns_zone_virtual_network_link" "ussc-dns-zone-link" {
  name                  = azurerm_relay_namespace.ussc-namespace.name
  resource_group_name = azurerm_resource_group.rg-network.name
  private_dns_zone_name = azurerm_private_dns_zone.global-private-dns-zone.name
  virtual_network_id    = azurerm_virtual_network.vnet-core-ussc.id
}

resource "azurerm_private_dns_a_record" "ussc-dns-a-record" {
  name                = azurerm_relay_namespace.ussc-namespace.name
  zone_name           = azurerm_private_dns_zone.global-private-dns-zone.name
  resource_group_name = azurerm_resource_group.rg-network.name
  ttl                 = 3600
  records             = ["10.0.0.116"]
}