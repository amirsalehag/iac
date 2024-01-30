# Auto create a readme file for terraform modules
The [terraform-docs](https://github.com/terraform-docs/terraform-docs) project automatically generates the modules documentations.
* Mount the modules directory to the container and output the doc into a file:
```bash
docker run -it --rm -u $(id -u) -v ${PWD}:/terraform-docs quay.io/terraform-docs/terraform-docs:0.17.0 markdown /terraform-docs > README.md
```
---

* output example:

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_http"></a> [http](#requirement\_http) | 3.4.0 |
| <a name="requirement_vsphere"></a> [vsphere](#requirement\_vsphere) | 2.6.1 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_vsphere"></a> [vsphere](#provider\_vsphere) | 2.6.1 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [vsphere_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/vsphere/2.6.1/docs/resources/virtual_machine) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_net_gateway"></a> [net\_gateway](#input\_net\_gateway) | Gateway for machines networks | `string` | n/a | yes |
| <a name="input_net_ip"></a> [net\_ip](#input\_net\_ip) | The starting point of assiging ip addresses for each VM | `number` | n/a | yes |

### Outputs

No outputs.
