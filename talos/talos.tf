resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  for_each           = { for k, v in local.vm : k => v if v.controlplane == true }
  cluster_name       = var.cluster_name
  machine_type       = "controlplane"
  cluster_endpoint   = "https://${each.value.public_ip_address}:6443"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  kubernetes_version = var.kubernetes_version
  talos_version      = var.talos_version
  docs               = true
  examples           = true
  config_patches = [templatefile("${path.module}/templates/patch.controlplane.yaml.tftpl", {
    hostname              = "${var.vm_zone}-${each.key}",
    nameservers           = var.net_nameservers,
    public_netmask        = var.public_net_netmask,
    private_netmask       = var.private_net_netmask,
    public_address        = each.value.public_ip_address,
    private_address       = each.value.private_ip_address,
    public_vlanid         = var.vlan_tag_public,
    private_vlanid        = var.vlan_tag_private,
    public_gateway        = var.public_net_gateway,
    subnet                = var.private_subnet,
    vip                   = local.vip,
    private_registry      = var.private_registry_url,
    private_registry_user = var.private_registry_username,
    private_registry_pass = var.private_registry_password

  })]
}

data "talos_machine_configuration" "worker" {
  for_each           = { for k, v in local.vm : k => v if v.controlplane != true }
  cluster_name       = var.cluster_name
  machine_type       = "worker"
  cluster_endpoint   = "https://${each.value.public_ip_address}:6443"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  kubernetes_version = var.kubernetes_version
  talos_version      = var.talos_version
  config_patches = [templatefile("${path.module}/templates/patch.worker.yaml.tftpl", {
    hostname              = "${var.vm_zone}-${each.key}",
    nameservers           = var.net_nameservers,
    public_netmask        = var.public_net_netmask,
    private_netmask       = var.private_net_netmask,
    public_address        = each.value.public_ip_address,
    private_address       = each.value.private_ip_address,
    public_vlanid         = var.vlan_tag_public,
    private_vlanid        = var.vlan_tag_private,
    public_gateway        = var.public_net_gateway,
    subnet                = var.private_subnet,
    private_registry      = var.private_registry_url,
    private_registry_user = var.private_registry_username,
    private_registry_pass = var.private_registry_password
  })]
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = [for k, v in local.vm : v.public_ip_address if v.controlplane == true]
  endpoints            = [for k, v in local.vm : v.public_ip_address if v.controlplane == true]
}

resource "talos_machine_configuration_apply" "controlplane" {
  for_each                    = { for k, v in local.vm : k => v if v.controlplane == true }
  depends_on                  = [proxmox_vm_qemu.vm]
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane[each.key].machine_configuration
  node                        = each.value.public_ip_address
  config_patches              = data.talos_machine_configuration.controlplane[each.key].config_patches
}

resource "talos_machine_configuration_apply" "worker" {
  for_each                    = { for k, v in local.vm : k => v if v.controlplane != true }
  depends_on                  = [proxmox_vm_qemu.vm]
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker[each.key].machine_configuration
  node                        = each.value.public_ip_address
  config_patches              = data.talos_machine_configuration.worker[each.key].config_patches
}

resource "talos_machine_bootstrap" "talos_nodes" {
  depends_on = [
    talos_machine_configuration_apply.controlplane
  ]
  node                 = tostring([for k, v in local.vm : v.public_ip_address if v.controlplane == true][0])
  client_configuration = talos_machine_secrets.this.client_configuration
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on = [
    talos_machine_bootstrap.talos_nodes
  ]
  certificate_renewal_duration = "8760h" # 1year
  client_configuration         = talos_machine_secrets.this.client_configuration
  node                         = tostring([for k, v in local.vm : v.public_ip_address if v.controlplane == true][0])
}
