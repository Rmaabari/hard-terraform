resource "awscc_ec2_instance" "main" {
  count           = var.replicas
  image_id        = var.ami
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  key_name        = var.ssh_key_name

  security_group_ids = [
    awscc_ec2_security_group.control_host.id
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
      { Name = "control-host" }
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


# resource "aws_instance" "main" {
#     count                       = var.replicas
#     ami                         = var.ami
#     instance_type               = var.instance_type
#     vpc_security_group_ids      = [aws_security_group.main.id]
#     subnet_id                   = var.subnet_id
#     private_ip                  = lookup(var.networking, "static_ip", "10.0.0.50")
#     key_name                    = var.ssh_key_name
#     root_block_device {
#         volume_size = var.disk_size
#         volume_type = "gp3"
#     }
#     iam_instance_profile        = aws_iam_instance_profile.control_efs.id
#     tags                        = merge(var.tags, {Name = "core-control-host"})
# }