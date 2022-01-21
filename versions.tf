terraform {
  required_version = ">=1.0.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.79.1"
    }
  }

  backend "azurerm" {
    resource_group_name  = "RG-TFSTATE"
    storage_account_name = "smithdavidaiatfstate01"
    container_name       = "tfstate"
    key                  = "mylab.state"
  }

}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}
