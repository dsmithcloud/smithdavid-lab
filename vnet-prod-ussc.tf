#================    VNET    ================
resource "azurerm_virtual_network" "vnet-prod-ussc" {
  name                = "vnet-prod-ussc-10.0.1.0_25"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "southcentralus"
  address_space       = ["10.0.1.0/25"]
  dns_servers         = var.ussc-adds-ip_address

  # ddos_protection_plan {
  #   id     = azurerm_network_ddos_protection_plan.ddos-plan.id
  #   enable = true
  # }

  tags = merge(local.settings.common_tags, local.settings.prod_tags)
}

resource "azurerm_subnet" "subnet-ussc-prod-fe" {
  name                 = "subnet-ussc-prod-vnet1-fe-10.0.1.0_27"
  virtual_network_name = azurerm_virtual_network.vnet-prod-ussc.name
  address_prefixes     = ["10.0.1.0/27"]
  resource_group_name  = azurerm_resource_group.rg-network.name
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
}

resource "azurerm_subnet" "subnet-ussc-prod-be" {
  name                 = "subnet-ussc-prod-vnet1-be-10.0.1.32_27"
  virtual_network_name = azurerm_virtual_network.vnet-prod-ussc.name
  address_prefixes     = ["10.0.1.32/27"]
  resource_group_name  = azurerm_resource_group.rg-network.name
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
}


#================    NSGs    ================
resource "azurerm_network_security_group" "nsg-ussc-prod-fe" {
  name                = "subnet-ussc-prod-vnet1-fe-nsg"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "southcentralus"

}

resource "azurerm_subnet_network_security_group_association" "nsg-ussc-prod-fe" {
  subnet_id                 = azurerm_subnet.subnet-ussc-prod-fe.id
  network_security_group_id = azurerm_network_security_group.nsg-ussc-prod-fe.id
}

resource "azurerm_network_security_group" "nsg-ussc-prod-be" {
  name                = "subnet-ussc-prod-vnet1-be-nsg"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "southcentralus"
}

resource "azurerm_subnet_network_security_group_association" "nsg-ussc-prod-be" {
  subnet_id                 = azurerm_subnet.subnet-ussc-prod-be.id
  network_security_group_id = azurerm_network_security_group.nsg-ussc-prod-be.id
}

#================    VWAN Connection    ================
resource "azurerm_virtual_hub_connection" "vnet-prod-ussc-hub2-connection" {
  name                      = "vnet-prod-ussc-hub2-connection"
  virtual_hub_id            = azurerm_virtual_hub.vwan-ussc-hub2.id
  remote_virtual_network_id = azurerm_virtual_network.vnet-prod-ussc.id
}
