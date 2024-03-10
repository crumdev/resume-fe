output "resource_group_name" {
  value = azurerm_resource_group.eastus-resume-fe-rg.name
}

output "storage_account_name" {
  value = azurerm_storage_account.eastus-resume-fe-sa.name
}

output "primary_web_host" {
  value = azurerm_storage_account.eastus-resume-fe-sa.primary_web_host
}