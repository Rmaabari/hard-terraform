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

output "app_network" {
  value = {
    port  = var.networking["app_ingress_port"]
    proto = var.networking["app_ingress_proto"]
  }
}