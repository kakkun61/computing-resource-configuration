# TTL の 1 は auto を意味する

resource "cloudflare_record" "root_a_1" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain
  type    = "A"
  content = "185.199.108.153"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "root_a_2" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain
  type    = "A"
  content = "185.199.109.153"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "root_a_3" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain
  type    = "A"
  content = "185.199.110.153"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "root_a_4" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain
  type    = "A"
  content = "185.199.111.153"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "root_aaaa_1" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain
  type    = "AAAA"
  content = "2606:50c0:8000::153"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "root_aaaa_2" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain
  type    = "AAAA"
  content = "2606:50c0:8001::153"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "root_aaaa_3" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain
  type    = "AAAA"
  content = "2606:50c0:8002::153"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "root_aaaa_4" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain
  type    = "AAAA"
  content = "2606:50c0:8003::153"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "fdm_3d_local" {
  zone_id = var.cloudflare_zone_id
  name    = "fdm-3d.local"
  type    = "A"
  content = "192.168.11.51"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "gmk_local" {
  zone_id = var.cloudflare_zone_id
  name    = "gmk.local"
  type    = "A"
  content = "192.168.11.52"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "printer_local" {
  zone_id = var.cloudflare_zone_id
  name    = "printer.local"
  type    = "A"
  content = "192.168.11.50"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "www" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  type    = "CNAME"
  content = "kakkun61.github.io"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "bsky" {
  zone_id = var.cloudflare_zone_id
  name    = "bsky"
  type    = "CNAME"
  content = "redirect.bsky.app"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "domainconnect" {
  zone_id = var.cloudflare_zone_id
  name    = "_domainconnect"
  type    = "CNAME"
  content = "_domainconnect.domains.squarespace.com"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "doujin" {
  zone_id = var.cloudflare_zone_id
  name    = "doujin"
  type    = "CNAME"
  content = "kakkun61.github.io"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "google_verification" {
  zone_id = var.cloudflare_zone_id
  name    = "fddo5yuqduqu"
  type    = "CNAME"
  content = "gv-skajdjtjjzil7b.dv.googlehosted.com"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "pdfding" {
  zone_id = var.cloudflare_zone_id
  name    = "pdfding"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.home.id}.cfargotunnel.com"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "argocd" {
  zone_id = var.cloudflare_zone_id
  name    = "argocd"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.home.id}.cfargotunnel.com"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "immich" {
  zone_id = var.cloudflare_zone_id
  name    = "immich"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.home.id}.cfargotunnel.com"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "photo_film_dev" {
  zone_id = var.cloudflare_zone_id
  name    = "photo-film-dev"
  type    = "CNAME"
  content = "kakkun61.github.io"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "slide" {
  zone_id = var.cloudflare_zone_id
  name    = "slide"
  type    = "CNAME"
  content = "kakkun61.github.io"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "mx_1" {
  zone_id  = var.cloudflare_zone_id
  name     = var.domain
  type     = "MX"
  content  = "aspmx.l.google.com"
  priority = 1
  ttl      = 1
  proxied  = false
}

resource "cloudflare_record" "mx_2" {
  zone_id  = var.cloudflare_zone_id
  name     = var.domain
  type     = "MX"
  content  = "alt1.aspmx.l.google.com"
  priority = 5
  ttl      = 1
  proxied  = false
}

resource "cloudflare_record" "mx_3" {
  zone_id  = var.cloudflare_zone_id
  name     = var.domain
  type     = "MX"
  content  = "alt2.aspmx.l.google.com"
  priority = 5
  ttl      = 1
  proxied  = false
}

resource "cloudflare_record" "mx_4" {
  zone_id  = var.cloudflare_zone_id
  name     = var.domain
  type     = "MX"
  content  = "alt3.aspmx.l.google.com"
  priority = 10
  ttl      = 1
  proxied  = false
}

resource "cloudflare_record" "mx_5" {
  zone_id  = var.cloudflare_zone_id
  name     = var.domain
  type     = "MX"
  content  = "alt4.aspmx.l.google.com"
  priority = 10
  ttl      = 1
  proxied  = false
}

resource "cloudflare_record" "ns_1" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain
  type    = "NS"
  content = "ns-cloud-a1.googledomains.com"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "ns_2" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain
  type    = "NS"
  content = "ns-cloud-a2.googledomains.com"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "ns_3" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain
  type    = "NS"
  content = "ns-cloud-a3.googledomains.com"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "ns_4" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain
  type    = "NS"
  content = "ns-cloud-a4.googledomains.com"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "spf" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain
  type    = "TXT"
  content = "v=spf1 include:_spf.google.com include:mailgun.org ~all"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "google_site_verification" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain
  type    = "TXT"
  content = "google-site-verification=WERGWCBwQpV-KqKngQ-3dhYBSmS38DRTfauNfK7_2S4"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "atproto" {
  zone_id = var.cloudflare_zone_id
  name    = "_atproto"
  type    = "TXT"
  content = "did=did:plc:qhtwcobptuvv66gowmnmsjpx"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "dmarc_1" {
  zone_id = var.cloudflare_zone_id
  name    = "_dmarc"
  type    = "TXT"
  content = "v=DMARC1; p=reject; rua=mailto:kakkun61+cloudflare.com@gmail.com"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "dmarc_2" {
  zone_id = var.cloudflare_zone_id
  name    = "_dmarc"
  type    = "TXT"
  content = "v=DMARC1; p=none; rua=mailto:a5e8a887b05a44048de6c9fca0206e1b@dmarc-reports.cloudflare.net"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "dnslink_icon" {
  zone_id = var.cloudflare_zone_id
  name    = "_dnslink.icon"
  type    = "TXT"
  content = "dnslink=/ipfs/QmZgGSiJ7LoUhqpfjnDgaDVa4Eg38ZPFUXrqGvasb4YUoR"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "google_domainkey" {
  zone_id = var.cloudflare_zone_id
  name    = "google._domainkey"
  type    = "TXT"
  content = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArck5ImDiwqiJ7vbKm1fF+wvnH+OqBCPaQw5lN0wOHHJCYfuWvYCHs/UtEzS8Y3mzZLKMvpKZCBXbKf0XWXvPqFp0QQPWcQRCJxXHG4t6Z6Fxh1Yb+0xKYxR0tLZNOlYZlH3Z1vKLGh8fqQ4U6K5z7RWQtNxPpMZcVp8qmQZLKF6L5b6Vz5zZpJH5Qg5K5H5F5T5V5L5D5W5J5K5G5N5M5L5P5Q5R5S5T5U5V5W5X5Y5Z5a5b5c5d5e5f5g5h5i5j5k5l5m5n5o5p5q5r5s5t5u5v5w5x5y5z5A5B5C5D5E5F5G5H5I5J5K5L5M5N5O5P5Q5R5S5T5U5V5W5X5Y5Z5QIDAQAB"
  ttl     = 1
  proxied = false
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "home" {
  account_id = var.cloudflare_account_id
  name       = var.tunnel_name
  secret     = ""

  # 既存Tunnelの場合、secretの変更を無視
  lifecycle {
    ignore_changes = [secret]
  }
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "home" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.home.id

  config {
    ingress_rule {
      hostname = "pdfding.${var.domain}"
      service  = "http://localhost:80"
    }

    ingress_rule {
      hostname = "argocd.${var.domain}"
      service  = "http://localhost:80"
    }

    ingress_rule {
      hostname = "immich.${var.domain}"
      service  = "http://localhost:80"
    }

    ingress_rule {
      service = "http_status:404"
    }
  }
}
