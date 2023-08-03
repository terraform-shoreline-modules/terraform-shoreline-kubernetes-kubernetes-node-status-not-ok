terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "kubernetes_node_status_not_ok" {
  source    = "./modules/kubernetes_node_status_not_ok"

  providers = {
    shoreline = shoreline
  }
}