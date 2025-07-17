resource "cloudflare_zone" "crumdev" {
  account = {
    id = "eb6a194a28496098ab4133c7d82ce512"
  }
  name = "crumdev.com"
  type = "full"
}

resource "cloudflare_dns_record" "cname_azure_static_resume_fe" {
  zone_id = cloudflare_zone.crumdev.id
  name    = "@" # or "www" if you want www.crumdev.com
  type    = "CNAME"
  comment = "CNAME to Azure CDN for Resume Frontend"
  content = azurerm_cdn_endpoint.resume_fe_cdn_endpoint.host_name
  proxied = true
  ttl     = 1
}