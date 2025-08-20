resource "awscc_ec2_instance" "masters" {
  count                 = var.replicas["master"]
  image_id              = var.amis["master"]
  instance_type         = var.instance_types["master"]
  subnet_id             = var.subnet_id
  key_name              = var.ssh_key_name
  security_group_ids    = [ awscc_ec2_security_group.any_any_allow.id ]
  iam_instance_profile  = awscc_iam_instance_profile.aws_ebs_csi.id

  block_device_mappings = [{
    device_name = var.device_name
    ebs = {
      volume_size           = var.disk_sizes["master"]
      volume_type           = var.volume_type
      delete_on_termination = true
    }
  }]

  tags = [
    for k, v in merge(
      local.tags,
      var.tags,
      { Name = "${var.cluster_name}-master-${count.index}" }
    ) : {
      key   = k
      value = v
    }
  ]
  lifecycle {
    ignore_changes = [   
      tags,
      block_device_mappings
    ]
  }

}


# ///
# ####
#     root_block_device {
#         volume_size = var.disk_sizes["master"]
#         volume_type = "gp3"
#     }
#     tags = merge(local.tags, {Name = "${var.cluster_name}-master-${count.index}"})
# }

resource "awscc_ec2_instance" "workers" {
  count         = var.replicas["worker"]
  image_id      = var.amis["worker"]
  instance_type = var.instance_types["worker"]
  subnet_id     = var.subnet_id
  key_name      = var.ssh_key_name

  # AWSCC wants security_group_ids, not vpc_security_group_ids
  security_group_ids = [
    awscc_ec2_security_group.any_any_allow.id
  ]

  iam_instance_profile = awscc_iam_instance_profile.aws_ebs_csi.id

  # block_device_mappings replaces root_block_device
  block_device_mappings = [
    {
      device_name = var.device_name
      ebs = {
        volume_size           = var.disk_sizes["worker"]
        volume_type           = var.volume_type
        delete_on_termination = true
      }
    }
  ]

  tags = [
    for k, v in merge(
      local.tags,
      var.tags,
      { Name = "${var.cluster_name}-worker-${count.index}" }
    ) : {
      key   = k
      value = v
    }
  ]

  lifecycle {
    ignore_changes = [   
      tags,
      block_device_mappings
    ]
  }

}

resource "awscc_ec2_instance" "loadbalancers" {
  count           = var.replicas["lb"]
  image_id        = var.amis["lb"]
  instance_type   = var.instance_types["lb"]
  subnet_id       = var.subnet_id
  key_name        = var.ssh_key_name
  security_group_ids = [
    awscc_ec2_security_group.any_any_allow.id
  ]
  iam_instance_profile = awscc_iam_instance_profile.aws_ebs_csi.id

  block_device_mappings = [
    {
      device_name = var.device_name
      ebs = {
        volume_size           = var.disk_sizes["lb"]
        volume_type           = var.volume_type
        delete_on_termination = true
      }
    }
  ]

  tags = [
    for k, v in merge(
      local.tags,
      var.tags,
      { Name = "${var.cluster_name}-lb-${count.index}" }
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