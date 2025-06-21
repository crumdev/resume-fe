resource "cloudflare_zone" "crumdev" {
  account = {
    id = "eb6a194a28496098ab4133c7d82ce512"
  }
  name = "crumdev.com"
  type = "full"
}

resource "cloudflare_dns_record" "cname_azure_static_resume_fe" {
  zone_id = cloudflare_zone.crumdev.id
  name    = "@"
  type    = "CNAME"
  comment = "Cname to Azure Static Resume Frontend"
  content = azurerm_storage_account.sa-eastus-resume-fe.primary_web_host
  proxied = true
  settings = {
    ipv4_only = true
  }
  ttl = 1
}