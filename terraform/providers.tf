provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}
