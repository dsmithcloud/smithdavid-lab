#================    VNET    ================
resource "azurerm_virtual_network" "vnet-prod-euw" {
  name = "vnet-prod-euw-10.1.1.0_25"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = azurerm_resource_group.rg-network.location
  address_space       = ["10.1.1.0/25"]
  dns_servers         = ["10.0.0.36", "10.0.0.37"]

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.ddos-plan.id
    enable = true
  }

  subnet {
    name           = "subnet-euw-prod-vnet1-fe-10.1.1.0_27"
    address_prefix = "10.1.1.0/27"
    security_group = azurerm_network_security_group.nsg-euw-prod-fe.id
    #service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  }

  subnet {
    name           = "subnet-euw-prod-vnet1-be-10.1.1.32_27"
    address_prefix = "10.1.1.32/27"
    security_group = azurerm_network_security_group.nsg-euw-prod-be.id
    #service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  }

tags = "${merge(local.settings.common_tags, local.settings.prod_tags)}"
}


#================    NSGs    ================
resource "azurerm_network_security_group" "nsg-euw-prod-fe" {
  name                = "subnet-euw-prod-vnet1-fe-nsg"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = azurerm_resource_group.rg-network.location
}

resource "azurerm_network_security_group" "nsg-euw-prod-be" {
  name                = "subnet-euw-prod-vnet1-be-nsg"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = azurerm_resource_group.rg-network.location
}


#================    VWAN Connection    ================
resource "azurerm_virtual_hub_connection" "vnet-prod-euw-hub2-connection" {
  name                      = "vnet-prod-euw-hub2-connection"
  virtual_hub_id            = azurerm_virtual_hub.vwan-hub2.id
  remote_virtual_network_id = azurerm_virtual_network.vnet-prod-euw.id
}
