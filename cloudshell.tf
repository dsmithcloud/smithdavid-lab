#================    Subnets    ================
resource "azurerm_subnet" "subnet-ussc-core-cloudshell" {
  name                 = "subnet-ussc-core-vnet1-cloudshell-10.0.0.96_27"
  address_prefixes     = ["10.0.0.96/27"]
  resource_group_name  = azurerm_resource_group.rg-network.name
  virtual_network_name = azurerm_virtual_network.vnet-core-ussc.name
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "delegation"
    service_delegation { name = "Microsoft.ContainerInstance/containerGroups" }
  }
}

resource "azurerm_subnet" "subnet-ussc-core-relay" {
  name                                           = "subnet-ussc-core-vnet1-relay-10.0.0.128_27"
  address_prefixes                               = ["10.0.0.128/27"]
  resource_group_name                            = azurerm_resource_group.rg-network.name
  virtual_network_name                           = azurerm_virtual_network.vnet-core-ussc.name
  enforce_private_link_endpoint_network_policies = true  #true = Disable; false = Enable
  enforce_private_link_service_network_policies  = false #true = Disable; false = Enable
}

resource "azurerm_subnet" "subnet-ussc-core-storage" {
  name                 = "subnet-ussc-core-vnet1-storage-10.0.0.160_27"
  address_prefixes     = ["10.0.0.160/27"]
  resource_group_name  = azurerm_resource_group.rg-network.name
  virtual_network_name = azurerm_virtual_network.vnet-core-ussc.name
  service_endpoints    = ["Microsoft.Storage"]
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
  tags = merge(local.settings.common_tags, local.settings.dev_tags)
}

#================    Relay Namespace   ================
resource "azurerm_relay_namespace" "ussc-namespace" {
  name                = "relay-core-ussc-namespace" # must be unique
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "southcentralus"
  sku_name            = "Standard"
  tags                = merge(local.settings.common_tags, local.settings.dev_tags)
}

#================    Role Assignments    ================
data "azurerm_subscription" "current" {
}

data "azuread_service_principal" "ACIService" {
  object_id = "6bb8e274-af5d-4df2-98a3-4fd78b4cafd9"
}

data "azurerm_role_definition" "contributorRoleDefinitionId" {
  role_definition_id = "b24988ac-6180-42a0-ab88-20f7382dd24c"
  scope              = data.azurerm_subscription.current.id
}

data "azurerm_role_definition" "networkRoleDefinitionId" {
  role_definition_id = "4d97b98b-1d4f-4787-a291-c67834d212e7"
  scope              = data.azurerm_subscription.current.id
}

resource "azurerm_role_assignment" "ussc-role-assignment-network" {
  name                 = uuid()
  scope                = azurerm_network_profile.vnet-core-ussc-networkprofile.id
  role_definition_name = data.azurerm_role_definition.networkRoleDefinitionId.name
  principal_id         = data.azuread_service_principal.ACIService.object_id
}

resource "azurerm_role_assignment" "ussc-role-assignment-contributor" {
  name                 = uuid()
  scope                = azurerm_network_profile.vnet-core-ussc-networkprofile.id
  role_definition_name = data.azurerm_role_definition.contributorRoleDefinitionId.name
  principal_id         = data.azuread_service_principal.ACIService.object_id
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
    subresource_names              = ["namespace"]
  }
  tags = merge(local.settings.common_tags, local.settings.dev_tags)
}

#================    Private DNS    ================
resource "azurerm_private_dns_zone" "global-private-dns-zone" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = azurerm_resource_group.rg-network.name
  tags                = merge(local.settings.common_tags, local.settings.dev_tags)
}

resource "azurerm_private_dns_zone_virtual_network_link" "ussc-dns-zone-link" {
  name                  = azurerm_relay_namespace.ussc-namespace.name
  resource_group_name   = azurerm_resource_group.rg-network.name
  private_dns_zone_name = azurerm_private_dns_zone.global-private-dns-zone.name
  virtual_network_id    = azurerm_virtual_network.vnet-core-ussc.id
}

resource "azurerm_private_dns_a_record" "ussc-dns-a-record" {
  name                = azurerm_relay_namespace.ussc-namespace.name
  zone_name           = azurerm_private_dns_zone.global-private-dns-zone.name
  resource_group_name = azurerm_resource_group.rg-network.name
  ttl                 = 3600
  records             = ["10.0.0.132"]
}

#================    Storage    ================
resource "azurerm_storage_account" "storussccorecshell" {
  name                     = "storussccorecshell"
  resource_group_name      = azurerm_resource_group.rg-network.name
  location                 = "southcentralus"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = merge(local.settings.common_tags, local.settings.core_tags, { ms-resource-usage = "azure-cloud-shell" })
}

resource "azurerm_storage_account_network_rules" "cshellstor-fwrules" {
  storage_account_id         = azurerm_storage_account.storussccorecshell.id
  default_action             = "Deny"
  virtual_network_subnet_ids = [azurerm_subnet.subnet-ussc-core-storage.id]
  depends_on = [
    azurerm_storage_share.cloudshell-dsmith
  ]
}

resource "azurerm_storage_share" "cloudshell-dsmith" {
  name                 = "cloudshell-dsmith"
  storage_account_name = azurerm_storage_account.storussccorecshell.name
  quota                = 50
}
