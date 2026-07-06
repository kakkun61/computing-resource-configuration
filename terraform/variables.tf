variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
}

variable "domain" {
  description = "メインドメイン名"
  type        = string
}

variable "tunnel_name" {
  description = "Cloudflare Tunnel 名"
  type        = string
  default     = "my-tunnel"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-northeast-3"
}

variable "aws_account_id" {
  description = "AWS アカウント ID"
  type        = string
  sensitive   = true
}
