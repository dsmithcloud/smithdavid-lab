variable "policies" {
  type = map(object({
    name = string
    policy_id = string
    parameters = string
  }))
  default = {
      "0" = {
        name = "Enable Azure Monitor for VMs - EUW"
        policy_id = "/providers/Microsoft.Authorization/policySetDefinitions/55f3eceb-5573-4f18-9695-226972c6d74a"
        parameters = <<PARAMETERS
        {
            "logAnalytics": {
                "value": "/subscriptions/a086e6e3-3a0f-45fb-aa14-1d53e4308040/resourcegroups/rg-euw-core-log/providers/microsoft.operationalinsights/workspaces/euw-core-log"
            }
        }
        PARAMETERS
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
      },
      "2" = {
        name = "Storage accounts should restrict network access"
        policy_id = "/providers/Microsoft.Authorization/policyDefinitions/2a1a9cdf-e04d-429a-8416-3bfb72a1b26f"
        parameters = null
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
}