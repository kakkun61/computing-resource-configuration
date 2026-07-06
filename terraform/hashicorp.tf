terraform {
  required_version = "~> 1.15.6"
  cloud {
    organization = "kakkun61-home"
    workspaces {
      name = "home"
    }
  }
}
