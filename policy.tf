variable "policies" {
  type = map(object({
    name = string
    policy_id = string
    parameters = any
  }))
  default = {
      "0" = {
        name = "Enable Azure Monitor for VMs - EUW"
        policy_id = "/providers/Microsoft.Authorization/policySetDefinitions/55f3eceb-5573-4f18-9695-226972c6d74a"
        parameters = {
            "logAnalytics_1": "23a2774b-841d-4d8a-b0cd-f69c23b22464"
        }
      },
      "1" = {
        name = "Enable Azure Monitor for VMs - USSC"
        policy_id = "/providers/Microsoft.Authorization/policySetDefinitions/55f3eceb-5573-4f18-9695-226972c6d74a"
        parameters = {
            "logAnalytics_1": "fabb6e89-565c-429b-8a03-688b7fdef4e5"
        }
      },
      "2" = {
        name = "Storage accounts should restrict network access"
        policy_id = "/providers/Microsoft.Authorization/policyDefinitions/2a1a9cdf-e04d-429a-8416-3bfb72a1b26f"
        parameters = {}
      }
  }
}

data azurerm_subscription "current" {}

resource "azurerm_subscription_policy_assignment" "example" {
  for_each = var.policies
  name                 = each.value.name
  policy_definition_id = each.value.policy_id
  parameters           = jsonencode(each.value.parameters)
  subscription_id      = data.azurerm_subscription.current.id
}