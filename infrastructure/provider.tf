terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "us-east-resume-iac-rg"
    storage_account_name = "crumresumeiac"
    container_name       = "us-east-resume-iac-container"
    key                  = "terraform.tfstate"
  }
}
