resource "awscc_ec2_instance" "main" {
  image_id                    = var.image_id
  instance_type               = var.instance_type
  security_group_ids          = [awscc_ec2_security_group.main.id]
  subnet_id                   = var.subnet_id
  key_name                    = var.ssh_key_name
  #associate_public_ip_address = false
  # Conditionally set the private_ip if oxy_carrier_replicas is 1
  #private_ip = var.oxy_carrier_replicas == 1 ? var.networking["static_ip"] : null

  block_device_mappings = [
    {
      device_name = var.device_name
      ebs = {
        volume_size           = var.volume_size
        volume_type           = var.volume_type
        delete_on_termination = true
      }
    }
  ]


tags = [
  for k in sort(keys(
    merge(
      var.tags,
      { Name = "bastion" }
    )
  )) : {
    key   = k
    value = merge(
      var.tags,
      { Name = "bastion" }
    )[k]
  }
]
  
  lifecycle {
    ignore_changes = [   
      additional_info,
      affinity,
      block_device_mappings,
      user_data,
      tags
    ]
  }

}

#resource "awscc_ec2_eip_association" "eip_assoc" {
#  count         = var.oxy_carrier_replicas == 1 ? 1 : 1
#  instance_id   = awscc_ec2_instance.main.id
#  allocation_id = var.networking["eip_aloccation_id"]
#}
