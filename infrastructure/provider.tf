terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

provider "azurerm" {
  subscription_id = "bf85ae72-724c-48ae-88a8-8910937babb3"
  features {}
}

provider "cloudflare" {
  # Reads from CLOUDFLARE_API_TOKEN environment variable
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-eastus2-terraform"
    storage_account_name = "saeastus2tf"
    container_name       = "container-eastus2-tfstate"
    key                  = "terraform.tfstate"
  }
}
