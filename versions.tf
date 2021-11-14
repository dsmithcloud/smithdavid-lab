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
  subscription_id = "a086e6e3-3a0f-45fb-aa14-1d53e4308040"
  features {}
}
