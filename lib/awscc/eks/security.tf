# resource "awscc_ec2_security_group" "eks_cluster" {
#   name        = "${var.cluster_name}-sg"
#   description = "EKS control-plane SG"
#   vpc_id      = var.vpc_id

#   ingress = [{
#     description      = "Allow worker node to control-plane"
#     ip_protocol      = "tcp"
#     from_port        = 443
#     to_port          = 443
#     cidr_blocks      = var.node_cidr_blocks
#   }]

#   egress = [{
#     description = "All outbound"
#     ip_protocol = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }]

#   tags = var.tags
# }