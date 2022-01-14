#================    VNET    ================
resource "azurerm_virtual_network" "vnet-core-euw" {
  name                = "vnet-core-euw-10.1.0.0_22"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "westeurope"
  address_space       = ["10.1.0.0/22"]
  dns_servers         = concat(local.settings.adds.euw-adds-ip_address, local.settings.adds.ussc-adds-ip_address)

  # ddos_protection_plan {
  #   id     = azurerm_network_ddos_protection_plan.ddos-plan.id
  #   enable = true
  # }

  tags = merge(local.settings.common_tags, local.settings.core_tags)
}

#================    Subnets    ================
resource "azurerm_subnet" "subnet-euw-core-adds" {
  name                 = "subnet-euw-core-vnet1-adds-10.1.0.64_27"
  address_prefixes     = ["10.1.0.64/27"]
  resource_group_name  = azurerm_resource_group.rg-network.name
  virtual_network_name = azurerm_virtual_network.vnet-core-euw.name
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
}

resource "azurerm_subnet" "subnet-euw-core-mgmt" {
  name                 = "subnet-euw-core-vnet1-mgmt-10.1.0.96_27"
  address_prefixes     = ["10.1.0.96/27"]
  resource_group_name  = azurerm_resource_group.rg-network.name
  virtual_network_name = azurerm_virtual_network.vnet-core-euw.name
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
}

#================    NSGs    ================
resource "azurerm_network_security_group" "nsg-euw-adds" {
  name                = "subnet-euw-core-vnet1-adds-nsg"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "westeurope"
}

resource "azurerm_subnet_network_security_group_association" "nsg-euw-adds" {
  subnet_id                 = azurerm_subnet.subnet-euw-core-adds.id
  network_security_group_id = azurerm_network_security_group.nsg-euw-adds.id
}

resource "azurerm_network_security_group" "nsg-euw-mgmt" {
  name                = "subnet-euw-core-vnet1-mgmt-nsg"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "westeurope"
}

resource "azurerm_subnet_network_security_group_association" "nsg-euw-mgmt" {
  subnet_id                 = azurerm_subnet.subnet-euw-core-mgmt.id
  network_security_group_id = azurerm_network_security_group.nsg-euw-mgmt.id
}

#================    VWAN Connection    ================
resource "azurerm_virtual_hub_connection" "vnet-core-euw-hub2-connection" {
  name                      = "vnet-core-euw-hub2-connection"
  virtual_hub_id            = azurerm_virtual_hub.vwan-euw-hub1.id
  remote_virtual_network_id = azurerm_virtual_network.vnet-core-euw.id
}
