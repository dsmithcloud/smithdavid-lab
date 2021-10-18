variable "policies" {
  type = map(object({
    name = string
    policy_id = string
  }))
  default = {
      "policy1" = {
        name = "Enable Azure Monitor for VMs"
        policy_id = "/providers/Microsoft.Authorization/policySetDefinitions/55f3eceb-5573-4f18-9695-226972c6d74a"
      },
      "policy2" = {
        name = "Storage accounts should restrict network access using virtual network rules"
        policy_id = "/providers/Microsoft.Authorization/policyDefinitions/2a1a9cdf-e04d-429a-8416-3bfb72a1b26f"
      }
  }
}

data azurerm_subscription "current" {}

resource "azurerm_subscription_policy_assignment" "example" {
  for_each = var.policies
  name                 = each.value.name
  policy_definition_id = each.value.policy_id
  subscription_id      = data.azurerm_subscription.current.id
}