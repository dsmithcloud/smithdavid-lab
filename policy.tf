# variable "policy" {
#   type = map(object({
#     name       = string
#     policy_id  = string
#     parameters = string
#     location   = string
#   }))
# }

# policy = local.settings.policy

data "azurerm_subscription" "current" {}

resource "azurerm_subscription_policy_assignment" "policyAssignment" {
  for_each = local.settings.policies

  name                 = each.value["name"]
  policy_definition_id = each.value["policy_id"]
  parameters           = each.value["parameters"]
  subscription_id      = data.azurerm_subscription.current.id
  location             = each.value["location"]

  dynamic "identity" {
    for_each = each.value["identity"] ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  dynamic "identity" {
    for_each = each.value["identity"] ? [] : [1]
    content {
      type = null
    }
  }
}
