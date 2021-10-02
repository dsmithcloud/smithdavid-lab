resource "azurerm_log_analytics_workspace" "loganalytics" {
  name                = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.resourcelabels.loganalytics}"
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name
  sku                 = local.settings.loganalytics.sku
  retention_in_days   = local.settings.loganalytics.retention
  count               = local.settings.enable_loganalytics ? 1 : 0
  tags                = local.settings.tags
}

# Solutions

 resource "azurerm_log_analytics_solution" "solution1" {
  solution_name         = local.settings.loganalytics.solution1.name
  location              = azurerm_resource_group.monitoring.location
  resource_group_name   = azurerm_resource_group.monitoring.name
  workspace_resource_id = azurerm_log_analytics_workspace.loganalytics[count.index].id
  workspace_name        = azurerm_log_analytics_workspace.loganalytics[count.index].name
  count                 = local.settings.enable_loganalytics && local.settings.loganalytics.solution1.enabled ? 1 : 0

  plan {
    publisher = local.settings.loganalytics.solution1.publisher
    product   = local.settings.loganalytics.solution1.product
    
  }
}

 resource "azurerm_log_analytics_solution" "solution2" {
  solution_name         = local.settings.loganalytics.solution2.name
  location              = azurerm_resource_group.monitoring.location
  resource_group_name   = azurerm_resource_group.monitoring.name
  workspace_resource_id = azurerm_log_analytics_workspace.loganalytics[count.index].id
  workspace_name        = azurerm_log_analytics_workspace.loganalytics[count.index].name
  count                 = local.settings.enable_loganalytics && local.settings.loganalytics.solution2.enabled ? 1 : 0

  plan {
    publisher = local.settings.loganalytics.solution2.publisher
    product   = local.settings.loganalytics.solution2.product
    
  }
}

 resource "azurerm_log_analytics_solution" "solution3" {
  solution_name         = local.settings.loganalytics.solution3.name
  location              = azurerm_resource_group.monitoring.location
  resource_group_name   = azurerm_resource_group.monitoring.name
  workspace_resource_id = azurerm_log_analytics_workspace.loganalytics[count.index].id
  workspace_name        = azurerm_log_analytics_workspace.loganalytics[count.index].name
  count                 = local.settings.enable_loganalytics && local.settings.loganalytics.solution3.enabled ? 1 : 0

  plan {
    publisher = local.settings.loganalytics.solution3.publisher
    product   = local.settings.loganalytics.solution3.product
    
  }
}

 resource "azurerm_log_analytics_solution" "solution4" {
  solution_name         = local.settings.loganalytics.solution4.name
  location              = azurerm_resource_group.monitoring.location
  resource_group_name   = azurerm_resource_group.monitoring.name
  workspace_resource_id = azurerm_log_analytics_workspace.loganalytics[count.index].id
  workspace_name        = azurerm_log_analytics_workspace.loganalytics[count.index].name
  count                 = local.settings.enable_loganalytics && local.settings.loganalytics.solution4.enabled ? 1 : 0

  plan {
    publisher = local.settings.loganalytics.solution4.publisher
    product   = local.settings.loganalytics.solution4.product
    
  }
}

 resource "azurerm_log_analytics_solution" "solution5" {
  solution_name         = local.settings.loganalytics.solution5.name
  location              = azurerm_resource_group.monitoring.location
  resource_group_name   = azurerm_resource_group.monitoring.name
  workspace_resource_id = azurerm_log_analytics_workspace.loganalytics[count.index].id
  workspace_name        = azurerm_log_analytics_workspace.loganalytics[count.index].name
  count                 = local.settings.enable_loganalytics && local.settings.loganalytics.solution5.enabled ? 1 : 0

  plan {
    publisher = local.settings.loganalytics.solution5.publisher
    product   = local.settings.loganalytics.solution5.product
    
  }
}

 resource "azurerm_log_analytics_solution" "solution6" {
  solution_name         = local.settings.loganalytics.solution6.name
  location              = azurerm_resource_group.monitoring.location
  resource_group_name   = azurerm_resource_group.monitoring.name
  workspace_resource_id = azurerm_log_analytics_workspace.loganalytics[count.index].id
  workspace_name        = azurerm_log_analytics_workspace.loganalytics[count.index].name
  count                 = local.settings.enable_loganalytics && local.settings.loganalytics.solution6.enabled ? 1 : 0

  plan {
    publisher = local.settings.loganalytics.solution6.publisher
    product   = local.settings.loganalytics.solution6.product
    
  }
}

 resource "azurerm_log_analytics_solution" "solution7" {
  solution_name         = local.settings.loganalytics.solution7.name
  location              = azurerm_resource_group.monitoring.location
  resource_group_name   = azurerm_resource_group.monitoring.name
  workspace_resource_id = azurerm_log_analytics_workspace.loganalytics[count.index].id
  workspace_name        = azurerm_log_analytics_workspace.loganalytics[count.index].name
  count                 = local.settings.enable_loganalytics && local.settings.loganalytics.solution7.enabled ? 1 : 0

  plan {
    publisher = local.settings.loganalytics.solution7.publisher
    product   = local.settings.loganalytics.solution7.product
    
  }
}

 resource "azurerm_log_analytics_solution" "solution8" {
  solution_name         = local.settings.loganalytics.solution8.name
  location              = azurerm_resource_group.monitoring.location
  resource_group_name   = azurerm_resource_group.monitoring.name
  workspace_resource_id = azurerm_log_analytics_workspace.loganalytics[count.index].id
  workspace_name        = azurerm_log_analytics_workspace.loganalytics[count.index].name
  count                 = local.settings.enable_loganalytics && local.settings.loganalytics.solution8.enabled ? 1 : 0

  plan {
    publisher = local.settings.loganalytics.solution8.publisher
    product   = local.settings.loganalytics.solution8.product
    
  }
}

 resource "azurerm_log_analytics_solution" "solution9" {
  solution_name         = local.settings.loganalytics.solution9.name
  location              = azurerm_resource_group.monitoring.location
  resource_group_name   = azurerm_resource_group.monitoring.name
  workspace_resource_id = azurerm_log_analytics_workspace.loganalytics[count.index].id
  workspace_name        = azurerm_log_analytics_workspace.loganalytics[count.index].name
  count                 = local.settings.enable_loganalytics && local.settings.loganalytics.solution9.enabled ? 1 : 0

  plan {
    publisher = local.settings.loganalytics.solution9.publisher
    product   = local.settings.loganalytics.solution9.product
    
  }
}

 resource "azurerm_log_analytics_solution" "solution10" {
  solution_name         = local.settings.loganalytics.solution10.name
  location              = azurerm_resource_group.monitoring.location
  resource_group_name   = azurerm_resource_group.monitoring.name
  workspace_resource_id = azurerm_log_analytics_workspace.loganalytics[count.index].id
  workspace_name        = azurerm_log_analytics_workspace.loganalytics[count.index].name
  count                 = local.settings.enable_loganalytics && local.settings.loganalytics.solution10.enabled ? 1 : 0

  plan {
    publisher = local.settings.loganalytics.solution10.publisher
    product   = local.settings.loganalytics.solution10.product
    
  }
}

 resource "azurerm_log_analytics_solution" "solution11" {
  solution_name         = local.settings.loganalytics.solution11.name
  location              = azurerm_resource_group.monitoring.location
  resource_group_name   = azurerm_resource_group.monitoring.name
  workspace_resource_id = azurerm_log_analytics_workspace.loganalytics[count.index].id
  workspace_name        = azurerm_log_analytics_workspace.loganalytics[count.index].name
  count                 = local.settings.enable_loganalytics && local.settings.loganalytics.solution11.enabled ? 1 : 0

  plan {
    publisher = local.settings.loganalytics.solution11.publisher
    product   = local.settings.loganalytics.solution11.product
    
  }
}

 resource "azurerm_log_analytics_solution" "solution12" {
  solution_name         = local.settings.loganalytics.solution12.name
  location              = azurerm_resource_group.monitoring.location
  resource_group_name   = azurerm_resource_group.monitoring.name
  workspace_resource_id = azurerm_log_analytics_workspace.loganalytics[count.index].id
  workspace_name        = azurerm_log_analytics_workspace.loganalytics[count.index].name
  count                 = local.settings.enable_loganalytics && local.settings.loganalytics.solution12.enabled ? 1 : 0

  plan {
    publisher = local.settings.loganalytics.solution12.publisher
    product   = local.settings.loganalytics.solution12.product
    
  }
}

 resource "azurerm_log_analytics_solution" "solution13" {
  solution_name         = local.settings.loganalytics.solution13.name
  location              = azurerm_resource_group.monitoring.location
  resource_group_name   = azurerm_resource_group.monitoring.name
  workspace_resource_id = azurerm_log_analytics_workspace.loganalytics[count.index].id
  workspace_name        = azurerm_log_analytics_workspace.loganalytics[count.index].name
  count                 = local.settings.enable_loganalytics && local.settings.loganalytics.solution13.enabled ? 1 : 0

  plan {
    publisher = local.settings.loganalytics.solution13.publisher
    product   = local.settings.loganalytics.solution13.product
    
  }
}