output "dns_records_summary" {
  description = "管理されているDNSレコードのサマリー"
  value = {
    total_a_records     = 7
    total_aaaa_records  = 4
    total_cname_records = 9
    total_mx_records    = 5
    total_ns_records    = 4
    total_txt_records   = 7
  }
}

output "tunnel_id" {
  description = "Cloudflare Tunnel ID"
  value       = cloudflare_zero_trust_tunnel_cloudflared.home.id
}

output "tunnel_cname" {
  description = "Tunnel CNAME (DNS設定用)"
  value       = "${cloudflare_zero_trust_tunnel_cloudflared.home.id}.cfargotunnel.com"
}

output "tunnel_token" {
  description = "Cloudflare Tunnel Token (cloudflaredクライアント用)"
  value       = cloudflare_zero_trust_tunnel_cloudflared.home.tunnel_token
  sensitive   = true
}

output "zone_id" {
  description = "Cloudflare Zone ID"
  value       = var.cloudflare_zone_id
}

output "account_id" {
  description = "Cloudflare Account ID"
  value       = var.cloudflare_account_id
}

output "immich_backup_s3_bucket_name" {
  description = "Immich バックアップ用 S3 バケット名"
  value       = aws_s3_bucket.immich_backup.bucket
  sensitive   = true
}

output "immich_backup_s3_bucket_arn" {
  description = "Immich バックアップ用 S3 バケット ARN"
  value       = aws_s3_bucket.immich_backup.arn
}
