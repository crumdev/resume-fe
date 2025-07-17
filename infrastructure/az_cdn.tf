resource "azurerm_cdn_profile" "resume_fe_cdn" {
  name                = "resume-fe-cdn"
  resource_group_name = azurerm_resource_group.rg-eastus-resume-fe.name
  location            = azurerm_resource_group.rg-eastus-resume-fe.location
  sku                 = "Standard_Microsoft"
}

resource "azurerm_cdn_endpoint" "resume_fe_cdn_endpoint" {
  name                = "resume-fe-cdn-endpoint"
  profile_name        = azurerm_cdn_profile.resume_fe_cdn.name
  resource_group_name = azurerm_cdn_profile.resume_fe_cdn.resource_group_name
  location            = azurerm_cdn_profile.resume_fe_cdn.location
  #   origin_host_header  = azurerm_storage_account.sa-eastus-resume-fe.primary_web_host
  #   origin_path         = "/${azurerm_storage_container.static_site_files.name}"
  is_http_allowed  = false
  is_https_allowed = true
  origin {
    name      = "resume-fe-origin"
    host_name = azurerm_storage_account.sa-eastus-resume-fe.primary_web_host
  }
}

resource "azurerm_cdn_endpoint_custom_domain" "example" {
  name            = "crumdev"
  cdn_endpoint_id = azurerm_cdn_endpoint.resume_fe_cdn_endpoint.id
  host_name       = "crumdev.com" # or "www.crumdev.com"
}

output "cdn_endpoint" {
  value = azurerm_cdn_endpoint.resume_fe_cdn_endpoint.fqdn
}