resource "azurerm_log_analytics_workspace" "ussc-core-log" {
  name                = "ussc-core-log"
  location            = azurerm_resource_group.ussc-law.location
  resource_group_name = azurerm_resource_group.ussc-law.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_workspace" "euw-core-log" {
  name                = "euw-core-log"
  location            = azurerm_resource_group.euw-law.location
  resource_group_name = azurerm_resource_group.euw-law.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_solution" "ussc-monitor-solutions" {
  for_each = toset(local.settings.adds.monitor_solutions)

  solution_name         = each.key
  location              = azurerm_resource_group.ussc-law.location
  resource_group_name   = azurerm_resource_group.ussc-law.name
  workspace_resource_id = azurerm_log_analytics_workspace.ussc-core-log.id
  workspace_name        = azurerm_log_analytics_workspace.ussc-core-log.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/${each.key}"
  }
}

resource "azurerm_log_analytics_solution" "euw-monitor-solutions" {
  for_each = toset(local.settings.adds.monitor_solutions)

  solution_name         = each.key
  location              = azurerm_resource_group.euw-law.location
  resource_group_name   = azurerm_resource_group.euw-law.name
  workspace_resource_id = azurerm_log_analytics_workspace.euw-core-log.id
  workspace_name        = azurerm_log_analytics_workspace.euw-core-log.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/${each.key}"
  }
}
