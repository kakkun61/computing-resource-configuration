provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "aws" {
  region  = var.aws_region
}
