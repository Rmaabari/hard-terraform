# resource "awscc_eks_cluster" "main" {
#   name        = "example-cluster"
#   role_arn     = awscc_iam_role.main.arn
#   security_group_ids    = [ awscc_ec2_security_group.eks_nodes.id ]
#   key_name   = var.key_name
#   resources_vpc_config = {
#     subnet_ids = var.subnet_ids
#     vpc_id     = var.vpc_id
#   }


#   tags = [{
#     key   = "Modified By"
#     value = "AWSCC"
#   }]
# }

# resource "awscc_iam_role" "main" {
#   name = "${var.cluster_name}-role"

#   assume_role_policy = jsonencode({
#     Version   = "2012-10-17"
#     Statement = [{
#       Effect    = "Allow"
#       Principal = { Service = "eks.amazonaws.com" }
#       Action    = "sts:AssumeRole"
#     }]
#   })

#   managed_policy_arns = [
#     "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   ]
# }