output "cluster_name" {
  value       = local.cluster_name
  description = "Name of the created cluster. This tag assigned to all created resources"
}

output "vpc_id" {
  value       = var.vpc_id
  description = "ID of the AWS VPC in which to create the cluster. If not set will be used the default vps"
}

output "subnet_id" {
    value     = var.subnet_id
}


output "master_nodes" {
  value = [
    for idx, node in awscc_ec2_instance.masters : {
      name       = lookup(
                     { for t in node.tags : t.key => t.value },
                     "Name", 
                     ""
                   )
      public_ip  = node.public_ip
      private_ip = node.private_ip
    }
  ]
}


# output "master_nodes" {
#     value = [
#         for node in awscc_ec2_instance.masters : {
#             name       = node.tags["Name"]
#             private_ip = node.private_ip
#         }
#     ]
# }


output "worker_nodes" {
  value = [
    for idx, node in awscc_ec2_instance.workers : {
      name       = lookup(
                     { for t in node.tags : t.key => t.value },
                     "Name", 
                     ""
                   )
      public_ip  = node.public_ip
      private_ip = node.private_ip
    }
  ]
}


# output "worker_nodes" {
#     value = [
#         for node in aws_instance.workers : {
#             name       = node.tags["Name"]
#             private_ip = node.private_ip
#         }
#     ]
# }

# output "loadbalancers" {
#     value = [
#         for node in aws_instance.loadbalancers : {
#             name       = node.tags["Name"]
#             private_ip = node.private_ip
#         }
#     ]
# }


output "loadbalancers" {
  value = [
    for idx, node in awscc_ec2_instance.loadbalancers : {
      name       = lookup(
                     { for t in node.tags : t.key => t.value },
                     "Name", 
                     ""
                   )
      public_ip  = node.public_ip
      private_ip = node.private_ip
    }
  ]
}



output "networking" {
    value = var.networking
}