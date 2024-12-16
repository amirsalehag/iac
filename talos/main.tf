locals {
  vm = merge(
    { for s, i in var.master_server_nodes : "master-${s}" => {
      public_ip_address  = "${var.public_net_subnet}.${var.master_last_subnet + s}"
      private_ip_address = "${var.private_net_subnet}.${var.master_last_subnet + s}"
      server             = "${var.proxmox_nodes}-${i}"
      vm_id              = tonumber("${var.master_vmid_start}${s}")
      gpu_node           = false
      controlplane       = true
      }
    },
    { for s, i in var.network_server_nodes : "network-${s}" => {
      public_ip_address  = "${var.public_net_subnet}.${var.network_last_subnet + s}"
      private_ip_address = "${var.private_net_subnet}.${var.network_last_subnet + s}"
      server             = "${var.proxmox_nodes}-${i}"
      vm_id              = tonumber("${var.network_vmid_start}${s}")
      gpu_node           = false
      controlplane       = false
      }
    },
    { for s, i in var.encoder_server_nodes : "encoder-${s}" => {
      public_ip_address  = "${var.public_net_subnet}.${var.encoder_last_subnet + s}"
      private_ip_address = "${var.private_net_subnet}.${var.encoder_last_subnet + s}"
      server             = "${var.proxmox_nodes}-${i}"
      vm_id              = tonumber("${var.encoder_vmid_start}${s}")
      gpu_node           = true
      controlplane       = false
      }
    }
  )
  bios_type    = "seabios"
  machine_type = "q35"
  boot_order   = "ide2"
  vip          = ""
}

resource "proxmox_vm_qemu" "vm" {
  for_each    = local.vm
  name        = "${var.vm_zone}-${each.key}"
  target_node = each.value.server
  vm_state    = "running"
  # clone       = var.base_clone_name
  os_type = "cloud-init"
  agent   = 1
  memory  = var.vm_memory
  sockets = 1
  cores   = var.vm_cpus
  vcpus   = var.vcpu_num
  cpu     = "host"
  # cpu_type = "host"
  scsihw  = "virtio-scsi-pci"
  hotplug = "network,disk,usb,memory,cpu"
  vmid    = each.value.vm_id
  boot    = "order=${local.boot_order}"
  numa    = true
  machine = local.machine_type
  bios    = local.bios_type
  qemu_os = "l26"

  disks {
    scsi {
      scsi0 {
        disk {
          size    = var.node_storage_size
          storage = var.node_storage
        }
      }
    }
    ide {
      ide2 {
        cdrom {
          iso = "${var.iso_storage}:iso/${var.talos_iso_name}"
        }
      }
      ide3 {
        cloudinit {
          storage = var.node_storage
        }
      }
    }
  }

  serial {
    id   = 0
    type = "socket"
  }

  ipconfig0  = "ip=${each.value.public_ip_address}/${var.public_net_netmask},gw=${var.public_net_gateway}"
  ipconfig1  = "ip=${each.value.private_ip_address}/${var.private_net_netmask}"
  nameserver = join(" ", var.net_nameservers)

  dynamic "network" {
    for_each = tolist([var.vlan_tag_public, var.vlan_tag_private])
    content {
      # id     = 0
      model  = "virtio"
      bridge = "vmbr0"
      tag    = network.value
    }
  }

  lifecycle {
    ignore_changes = [
      smbios,
      network
    ]
  }
}
