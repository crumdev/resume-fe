output "resource_group_name" {
  value = azurerm_resource_group.rg-eastus-resume-fe.name
}

output "storage_account_name" {
  value = azurerm_storage_account.sa-eastus-resume-fe.name
}

output "primary_web_host" {
  value = azurerm_storage_account.sa-eastus-resume-fe.primary_web_host
}