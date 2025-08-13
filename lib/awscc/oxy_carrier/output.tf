output "nodes" {
  value = [
    for idx, node in awscc_ec2_instance.main : {
      name       = lookup(
                     { for t in node.tags : t.key => t.value },
                     "Name",
                     ""
                   )
      private_ip = node.private_ip
    }
  ]
}

output "primary_nic" {
  # If you have multiple replicas, this outputs a list:
  value = awscc_ec2_instance.main[*].primary_network_interface_id

  # Or if you only care about the first instance:
  # value = awscc_ec2_instance.main[0].primary_network_interface_id
}
