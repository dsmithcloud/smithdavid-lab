variable "policies" {
  type = map(object({
    name = string
    policy_id = string
    parameters = string
    location = string
  }))
  default = {
      "0" = {
        name = "Enable Azure Monitor for VMs - EUW"
        policy_id = "/providers/Microsoft.Authorization/policySetDefinitions/55f3eceb-5573-4f18-9695-226972c6d74a"
        parameters = <<PARAMETERS
        {
            "logAnalytics_1": {
                "value": "/subscriptions/a086e6e3-3a0f-45fb-aa14-1d53e4308040/resourcegroups/rg-euw-core-log/providers/microsoft.operationalinsights/workspaces/euw-core-log"
            }
        }
        PARAMETERS
        location = "westeurope"
      },
      "1" = {
        name = "Enable Azure Monitor for VMs - USSC"
        policy_id = "/providers/Microsoft.Authorization/policySetDefinitions/55f3eceb-5573-4f18-9695-226972c6d74a"
        parameters = <<parameters
        {
            "logAnalytics_1": {
                "value": "/subscriptions/a086e6e3-3a0f-45fb-aa14-1d53e4308040/resourcegroups/rg-ussc-core-log/providers/microsoft.operationalinsights/workspaces/ussc-core-log"
            }
        }
        parameters
        location = "southcentralus"
      },
      "2" = {
        name = "Storage accounts should restrict network access"
        policy_id = "/providers/Microsoft.Authorization/policyDefinitions/2a1a9cdf-e04d-429a-8416-3bfb72a1b26f"
        parameters = null
        location = null
      },
      "3" = {
          name = "Allowed virtual machine size SKUs"
          policy_id = "/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3"
          parameters = <<PARAMETERS
          {
            "listOfAllowedSKUs": {
                "value": ["Standard_D2s_V3","Standard_B2s"]
            }
          }
          PARAMETERS
          location = "southcentralus"
      }
  }
}

data azurerm_subscription "current" {}

resource "azurerm_subscription_policy_assignment" "policyAssignment" {
  for_each = var.policies
  name                 = each.value.name
  policy_definition_id = each.value.policy_id
  parameters           = each.value.parameters
  subscription_id      = data.azurerm_subscription.current.id
  location = each.value.location
  identity {
    type = "SystemAssigned"
  }
}