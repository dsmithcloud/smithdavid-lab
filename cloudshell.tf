module "cloudshell-vnet" {
  source                       = "git::https://github.com/dsmithcloud/tf-cloudshell-vnet.git"
  existing-vnet-resource-group = azurerm_resource_group.rg-network.name
  existing-vnet-name           = azurerm_virtual_network.vnet-core-ussc.name
  ACI-OID                      = "88536fb9-d60a-4aee-8195-041425d6e927"
  container-subnet-name        = "subnet-ussc-core-vnet1-cloudshell-10.0.0.96_27"
  container-subnet-prefix      = ["10.0.0.96/27"]
  relay-subnet-name            = "subnet-ussc-core-vnet1-relay-10.0.0.128_26"
  relay-subnet-prefix          = ["10.0.0.128/26"]
  relay-namespace-name         = "subnet-ussc-core-vnet1-relay-namespace"
  storageaccount-name          = "storusscshell01"
  tags                         = merge(local.settings.common_tags, local.settings.core_tags)
}
