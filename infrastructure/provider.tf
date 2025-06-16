terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-eastus2-terraform"
    storage_account_name = "saeastus2tf"
    container_name       = "container-eastus2-tfstate"
    key                  = "terraform.tfstate"
  }
}
