resource "awscc_ec2_instance" "main" {
  count           = var.replicas
  image_id        = var.ami
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  key_name        = var.ssh_key_name

  security_group_ids = [
    awscc_ec2_security_group.dataml.id
  ]

  block_device_mappings = [
    {
      device_name = var.device_name  

      ebs = {
        volume_size           = var.disk_size
        volume_type           = var.volume_type
        delete_on_termination = true
      }
    }
  ]

  tags = [
    for k, v in merge(
      var.tags,
      { Name = "DataML-${count.index}" }
    ) : {
      key   = k
      value = v
    }
  ]

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}