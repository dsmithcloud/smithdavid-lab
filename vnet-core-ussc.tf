resource "azurerm_virtual_network" "vnet-core-ussc" {
  name = "vnet-core-ussc-10.0.0.0_25"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "southcentralus"
  address_space       = ["10.0.0.0/25"]
  dns_servers         = ["10.0.0.36", "10.0.0.37"]

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.ddos-plan.id
    enable = true
  }

  subnet {
    name           = "AzureBastionSubnet"
    address_prefix = "10.0.0.0/27"
  }

  subnet {
    name           = "subnet-ussc-core-vnet1-adds-10.0.0.32_27"
    address_prefix = "10.0.0.32/27"
    security_group = azurerm_network_security_group.nsg-adds.id
    #service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  }

  subnet {
    name           = "subnet-ussc-core-vnet1-mgmt-10.0.0.64_27"
    address_prefix = "10.0.0.64/27"
    security_group = azurerm_network_security_group.nsg-mgmt.id
    #service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  }

tags = "${merge(local.settings.common_tags, local.settings.core_tags)}"
}

resource "azurerm_network_security_group" "nsg-adds" {
  name                = "subnet-ussc-core-vnet1-adds-nsg"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "southcentralus"
}

resource "azurerm_network_security_group" "nsg-mgmt" {
  name                = "subnet-ussc-core-vnet1-mgmt-nsg"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "southcentralus"
}

resource "azurerm_virtual_hub_connection" "vnet-core-ussc-hub2-connection" {
  name                      = "vnet-core-ussc-hub2-connection"
  virtual_hub_id            = azurerm_virtual_hub.vwan-hub2.id
  remote_virtual_network_id = azurerm_virtual_network.vnet-core-ussc.id
}
