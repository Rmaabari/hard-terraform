resource "aws_instance" "main" {
    count                       = var.replicas
    ami                         = var.ami
    instance_type               = var.instance_type
    vpc_security_group_ids      = ["${aws_security_group.main.id}"]
    subnet_id                   = var.subnet_id
    key_name                    = var.ssh_key_name
    iam_instance_profile        = var.instance_profile
    root_block_device {
        volume_size = var.disk_size
        volume_type = "gp3"
    }
    tags = merge(var.tags, {Name = "engine-pestatic-${count.index}"})
}