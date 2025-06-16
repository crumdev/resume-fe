resource "azurerm_resource_group" "rg-eastus-resume-fe" {
  name     = "eastus-resume-fe-rg"
  location = "eastus"
}

resource "azurerm_storage_account" "sa-eastus-resume-fe" {
  name                = "sacrumdevresumefe"
  resource_group_name = azurerm_resource_group.rg-eastus-resume-fe.name
  location            = azurerm_resource_group.rg-eastus-resume-fe.location
  account_tier        = "Standard"
  account_kind        = "StorageV2"
  account_replication_type = "LRS"
}

// Add this new resource after your storage account
resource "azurerm_storage_account_static_website" "sw-eastus-resume-fe" {
  storage_account_id = azurerm_storage_account.sa-eastus-resume-fe.id
  index_document     = "index.html"
  error_404_document = "404NotFound.html"
}

locals {
  mime_types = jsondecode(file("${path.module}/mime.json"))
  site_path = "${path.root}/src"
}


resource "azurerm_storage_blob" "static_site_files" {
  for_each = fileset("${path.root}/../src/", "**/*")
  name                   = basename(each.key)
  storage_account_name   = azurerm_storage_account.sa-eastus-resume-fe.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${path.root}/../src/${each.key}"
  content_md5            = filemd5("${path.root}/../src/${each.key}")

  content_type = lookup(local.mime_types, try(regex("\\.[^.]+$", each.value), "default.txt"), "text")
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
#   origin_host_header  = azurerm_storage_account.sa-eastus-resume-fe.primary_web_host
#   origin_path         = "/${azurerm_storage_container.resume_fe_container.name}"
#   is_http_allowed     = false
#   is_https_allowed    = true
# }

# output "cdn_endpoint" {
#   value = azurerm_cdn_endpoint.resume_fe_cdn_endpoint.host_name
# }