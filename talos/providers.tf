terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc4"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.7.0-alpha.0"
    }
  }
  # backend "http" {
  # }
  required_version = "~> 1.9.8"
}

provider "proxmox" {
  pm_user         = var.proxmox_username
  pm_password     = var.proxmox_password
  pm_api_url      = var.proxmox_api_url
  pm_parallel     = var.parallel_proc
  pm_tls_insecure = true
}

provider "talos" {
}
