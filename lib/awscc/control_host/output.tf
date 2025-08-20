output "nodes" {
  value = [
    for _, node in awscc_ec2_instance.main : {
      name       = lookup(
                     { for t in node.tags : t.key => t.value },
                     "Name",
                     ""
                   )
      private_ip = node.private_ip
    }
  ]
}