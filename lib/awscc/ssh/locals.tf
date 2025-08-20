resource "random_pet" "ssh_key_name" {}

locals {
    ssh_key_name = var.ssh_key_name != null ? var.ssh_key_name : random_pet.ssh_key_name.id
    tags         = merge(var.tags, { Name = local.ssh_key_name})
}
