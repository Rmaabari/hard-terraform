data "template_file" "ssh_pubkey" {
  template = "${file(var.public_key_file_path)}"
}