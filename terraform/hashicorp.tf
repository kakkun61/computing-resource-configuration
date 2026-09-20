terraform {
  required_version = "~> 1.15.0"
  cloud {
    organization = "kakkun61-home"
    workspaces {
      name = "home"
    }
  }
}
