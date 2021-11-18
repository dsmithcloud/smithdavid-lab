module "cloudshell-vnet" {
  source                       = "./modules/cloudshell-vnet"
  region                       = "southcentralus"
  existing-vnet-name           = "vnet-core-ussc-10.0.0.0_24"
  existing-vnet-resource-group = "rg-global-core-network"
  ACI-OID                      = "88536fb9-d60a-4aee-8195-041425d6e927"
  container-subnet-prefix      = ["10.0.0.96/27"]
  relay-subnet-prefix          = ["10.0.0.128/26"]
  storageaccount-name          = "smithdavidshell"
  tags                         = merge(local.settings.common_tags, local.settings.core_tags)
}
