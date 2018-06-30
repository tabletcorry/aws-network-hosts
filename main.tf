//--------------------------------------------------------------------
// Variables
variable "resource_tags" {
  type        = "map"
  description = "Resource Tags"
}

variable "count" {
  default = 1
}

variable "vault_addr" {}
variable "machine_role" {}

//--------------------------------------------------------------------
// Modules
data "template_file" "init" {
  template = "${file("${path.root}/userdata.sh")}"

  vars {
    vault_addr   = "${var.vault_addr}"
    machine_role = "${var.machine_role}"
  }
}

module "network_host" {
  source        = "app.terraform.io/Darnold-Hashicorp/network-host/aws"
  version       = "1.3.7"
  user_data     = "${data.template_file.init.rendered}"
  count         = "${var.count}"
  network_ws    = "DemoNetwork-East"
  organization  = "Darnold-Hashicorp"
  resource_tags = "${var.resource_tags}"
}

output "hosts" {
  value = "${module.network_host.hosts}"
}

output "sec_group" {
  value = "${module.network_host.sec_group}"
}

output "instances" {
  value = "${module.network_host.instances}"
}

output "key_name" {
  value = "${module.network_host.key_name}"
}
