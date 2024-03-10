resource "azurerm_resource_group" "eastus-resume-fe-rg" {
  name     = "eastus-resume-fe-rg"
  location = "eastus"
}

resource "azurerm_storage_account" "eastus-resume-fe-sa" {
  name                = "crumdevresumefesa"
  resource_group_name = azurerm_resource_group.eastus-resume-fe-rg.name
  location            = azurerm_resource_group.eastus-resume-fe-rg.location
  account_tier        = "Standard"
  account_kind        = "StorageV2"
  static_website {
    index_document     = "index.html"
    error_404_document = "404NotFound.html"
  }
  account_replication_type = "GRS"
}

locals {
  mime_types = jsondecode(file("${path.module}/mime.json"))
}

resource "azurerm_storage_blob" "static_site_files" {
  for_each = fileset(path.module, "src/*")

  name                   = trim(each.key, "src/")
  storage_account_name   = azurerm_storage_account.eastus-resume-fe-sa.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = each.key
  content_md5            = filemd5(each.key)

  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), null)


}

# resource "azurerm_cdn_profile" "resume_fe_cdn" {
#   name                = "resume-fe-cdn"
#   resource_group_name = azurerm_resource_group.resume_fe.name
#   location            = azurerm_resource_group.resume_fe.location
#   sku                 = "Standard_Microsoft"
# }

# resource "azurerm_cdn_endpoint" "resume_fe_cdn_endpoint" {
#   name                = "resume-fe-cdn-endpoint"
#   profile_name        = azurerm_cdn_profile.resume_fe_cdn.name
#   resource_group_name = azurerm_resource_group.resume_fe.name
#   location            = azurerm_resource_group.resume_fe.location
#   origin_host_header  = azurerm_storage_account.eastus-resume-fe-sa.primary_web_host
#   origin_path         = "/${azurerm_storage_container.resume_fe_container.name}"
#   is_http_allowed     = false
#   is_https_allowed    = true
# }

# output "cdn_endpoint" {
#   value = azurerm_cdn_endpoint.resume_fe_cdn_endpoint.host_name
# }