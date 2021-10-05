# resource "azurerm_network_ddos_protection_plan" "ddos-plan" {
#   name                = "ddos-core-euw-plan1"
#   resource_group_name = azurerm_resource_group.rg-network.name
#   location            = azurerm_resource_group.rg-network.location
# }

resource "azurerm_virtual_network" "vnet-core-euw" {
  name = "vnet-core-euw-10.1.0.0_25"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = azurerm_resource_group.rg-network.location
  address_space       = ["10.1.0.0/25"]
  dns_servers         = ["10.1.0.36", "10.1.0.37"]

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.ddos-plan.id
    enable = true
  }

  subnet {
    name           = "AzureBastionSubnet"
    address_prefix = "10.1.0.0/27"
  }

  subnet {
    name           = "subnet-euw-core-vnet1-adds-10.1.0.32_27"
    address_prefix = "10.1.0.32/27"
    security_group = azurerm_network_security_group.nsg-euw-adds.id
    #service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  }

  subnet {
    name           = "subnet-euw-core-vnet1-mgmt-10.1.0.64_27"
    address_prefix = "10.1.0.64/227"
    security_group = azurerm_network_security_group.nsg-euw-mgmt.id
    #service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  }

tags = "${merge(local.settings.common_tags, local.settings.core_tags)}"
}

resource "azurerm_network_security_group" "nsg-euw-adds" {
  name                = "subnet-euw-core-vnet1-adds-nsg"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = azurerm_resource_group.rg-network.location
}

resource "azurerm_network_security_group" "nsg-euw-mgmt" {
  name                = "subnet-euw-core-vnet1-mgmt-nsg"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = azurerm_resource_group.rg-network.location
}

resource "azurerm_virtual_hub_connection" "vnet-core-euw-hub2-connection" {
  name                      = "vnet-core-euw-hub2-connection"
  virtual_hub_id            = azurerm_virtual_hub.vwan-hub2.id
  remote_virtual_network_id = azurerm_virtual_network.vnet-core-euw.id
}
