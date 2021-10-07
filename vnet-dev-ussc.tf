#================    VNET    ================
resource "azurerm_virtual_network" "vnet-dev-ussc" {
  name = "vnet-dev-ussc-10.0.2.0_25"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "southcentralus"
  address_space       = ["10.0.2.0/25"]
  dns_servers         = ["10.0.0.36", "10.0.0.37"]

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.ddos-plan.id
    enable = true
  }

  subnet {
    name           = "subnet-ussc-dev-vnet1-fe-10.0.2.0_27"
    address_prefix = "10.0.2.0/27"
    security_group = azurerm_network_security_group.nsg-ussc-dev-fe.id
    #service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  }

  subnet {
    name           = "subnet-ussc-dev-vnet1-be-10.0.2.32_27"
    address_prefix = "10.0.2.32/27"
    security_group = azurerm_network_security_group.nsg-ussc-dev-be.id
    #service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  }

tags = "${merge(local.settings.common_tags, local.settings.dev_tags)}"
}


#================    NSGs    ================
resource "azurerm_network_security_group" "nsg-ussc-dev-fe" {
  name                = "subnet-ussc-dev-vnet1-fe-nsg"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "southcentralus"
}

resource "azurerm_network_security_group" "nsg-ussc-dev-be" {
  name                = "subnet-ussc-dev-vnet1-be-nsg"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "southcentralus"
}


#================    VWAN Connection    ================
resource "azurerm_virtual_hub_connection" "vnet-dev-ussc-hub2-connection" {
  name                      = "vnet-dev-ussc-hub2-connection"
  virtual_hub_id            = azurerm_virtual_hub.vwan-ussc-hub2.id
  remote_virtual_network_id = azurerm_virtual_network.vnet-dev-ussc.id
}
