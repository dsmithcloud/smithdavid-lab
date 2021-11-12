#================    VNET    ================
resource "azurerm_virtual_network" "vnet-core-ussc" {
  name = "vnet-core-ussc-10.0.0.0_24"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "southcentralus"
  address_space       = ["10.0.0.0/24"]
  dns_servers         = ["10.0.0.36", "10.0.0.37"]

  # ddos_protection_plan {
  #   id     = azurerm_network_ddos_protection_plan.ddos-plan.id
  #   enable = true
  # } 

tags = "${merge(local.settings.common_tags, local.settings.core_tags)}"
}

#================    Subnets    ================
resource "azurerm_subnet" "subnet-ussc-core-bastion" {
    name           = "AzureBastionSubnet"
    address_prefixes = ["10.0.0.0/27"]
    resource_group_name = azurerm_resource_group.rg-network.name
    virtual_network_name = azurerm_virtual_network.vnet-core-ussc.name
}

resource "azurerm_subnet" "subnet-ussc-core-adds" {
    name           = "subnet-ussc-core-vnet1-adds-10.0.0.32_27"
    address_prefixes = ["10.0.0.32/27"]
    resource_group_name = azurerm_resource_group.rg-network.name
    virtual_network_name = azurerm_virtual_network.vnet-core-ussc.name
    service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
}

resource "azurerm_subnet" "subnet-ussc-core-mgmt" {
    name           = "subnet-ussc-core-vnet1-mgmt-10.0.0.64_27"
    address_prefixes = ["10.0.0.64/27"]
    resource_group_name = azurerm_resource_group.rg-network.name
    virtual_network_name = azurerm_virtual_network.vnet-core-ussc.name
    service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
}

#================    NSGs    ================
resource "azurerm_network_security_group" "nsg-adds" {
  name                = "subnet-ussc-core-vnet1-adds-nsg"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "southcentralus"
}

resource "azurerm_subnet_network_security_group_association" "nsg-adds" {
  subnet_id                 = azurerm_subnet.subnet-ussc-core-adds.id
  network_security_group_id = azurerm_network_security_group.nsg-adds.id
}

resource "azurerm_network_security_group" "nsg-mgmt" {
  name                = "subnet-ussc-core-vnet1-mgmt-nsg"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "southcentralus"
}

resource "azurerm_subnet_network_security_group_association" "nsg-mgmt" {
  subnet_id                 = azurerm_subnet.subnet-ussc-core-mgmt.id
  network_security_group_id = azurerm_network_security_group.nsg-mgmt.id
}

#================    Hub Connection    ================
resource "azurerm_virtual_hub_connection" "vnet-core-ussc-hub2-connection" {
  name                      = "vnet-core-ussc-hub2-connection"
  virtual_hub_id            = azurerm_virtual_hub.vwan-ussc-hub2.id
  remote_virtual_network_id = azurerm_virtual_network.vnet-core-ussc.id
}
