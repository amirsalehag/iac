variable "proxmox_api_url" {
  description = "Proxmox api url."
  type        = string
  sensitive   = true
}

variable "proxmox_password" {
  description = "proxmox password."
  type        = string
  sensitive   = true
}

variable "proxmox_username" {
  description = "proxmox username."
  type        = string
  sensitive   = true
}

variable "proxmox_nodes" {
  description = "proxmox host names."
  type        = string
  default     = "si1-VOD-infra-pizza"
}

variable "parallel_proc" {
  description = "Allowed simultaneous Proxmox processes."
  type        = number
  default     = 1
}

variable "base_clone_name" {
  description = "Clone template name."
  type        = string
}

variable "master_server_nodes" {
  description = "Where network nodes are created."
  type        = list(string)
  default     = ["0"]
}

variable "network_server_nodes" {
  description = "Where network nodes are created."
  type        = list(string)
  default     = ["0"]
}

variable "encoder_server_nodes" {
  description = "Where network nodes are created."
  type        = list(string)
  default     = ["0"]
}

variable "vm_zone" {
  type    = string
  default = "si1-stg"
}

variable "public_net_gateway" {
  description = "Gateway for machines networks."
  type        = string
  default     = "185.228.238.113"
}

variable "public_net_subnet" {
  description = "Subnet for the vm network."
  type        = string
  default     = "185.228.238"
}

variable "private_net_subnet" {
  description = "Subnet for the vm network."
  type        = string
  default     = "172.20.20"
}

variable "private_subnet" {
  description = "Subnet for cluster ip range."
  type        = string
}

variable "master_last_subnet" {
  description = "Subnet for the vm network."
  type        = string
  default     = "125"
}

variable "network_last_subnet" {
  description = "Subnet for the vm network."
  type        = string
  default     = "117"
}

variable "encoder_last_subnet" {
  description = "Subnet for the vm network."
  type        = string
  default     = "124"
}

variable "public_net_netmask" {
  type    = string
  default = "28"
}

variable "private_net_netmask" {
  type    = string
  default = "24"
}

variable "vlan_tag_public" {
  description = "Vlan tag id number for public network interface."
  type        = number
}

variable "vlan_tag_private" {
  description = "Vlan tag id number for private network interface."
  type        = number
}

variable "vm_cpus" {
  description = "number of cpu cores."
  type        = number
  default     = 2
}

variable "vcpu_num" {
  description = "number of vcpu's."
  type        = number
  default     = 0
}

variable "vm_memory" {
  description = "number of memory in byte."
  type        = number
  default     = 4096
}

variable "master_vmid_start" {
  description = "The starting number of vm id's.(end result: 220,221...)"
  type        = number
  default     = 20
}

variable "network_vmid_start" {
  description = "The starting number of vm id's.(end result: 210,211...)"
  type        = number
  default     = 21
}

variable "encoder_vmid_start" {
  description = "The starting number of vm id's.(end result: 220,221...)"
  type        = number
  default     = 22
}

variable "node_storage" {
  description = "Nodes storage disks."
  type        = string
  default     = "local-lvm"
}

variable "iso_storage" {
  description = "Iso storage name."
  type        = string
  default     = "local"
}

variable "talos_iso_name" {
  description = "talos iso name."
  type        = string
  default     = ""
}

variable "node_storage_size" {
  description = "Nodes storage disks."
  type        = number
  default     = 50
}

variable "talos_version" {
  description = "talos OS version."
  type        = string
  default     = ""
}

variable "kubernetes_version" {
  description = "kubernetes cluster version."
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "Kubernetes cluster name."
  type        = string
  default     = "kubernetes"
}

variable "net_nameservers" {
  type        = list(string)
  description = "Nameservers list"
  default     = ["8.8.8.8", "1.1.1.1"]
}

variable "private_registry_url" {
  description = "Private registry path."
  type        = string
}

variable "private_registry_username" {
  description = "Private registry authentication username."
  type        = string
}

variable "private_registry_password" {
  description = "Private registry authentication password."
  type        = string
  # sensitive   = true
}
