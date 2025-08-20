output "nodes" {
    value = [
        for node in aws_instance.main : {
            name       = node.tags["Name"]
            private_ip = node.private_ip,
        }
    ]
}

output "app_network" {
    value = {
        port  = "${var.networking["app_ingress_port"]}"
        proto = "${var.networking["app_ingress_proto"]}"
    }
}