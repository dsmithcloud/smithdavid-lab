terraform {
  required_version = ">= 0.12"

  backend "azurerm" {
    # Configured in the pipeline
  }
} 

provider "azurerm" {
  #version = ">=1.35.0"   deprecated
  subscription_id = var.subscription_id
  features{}
}
