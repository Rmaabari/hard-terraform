# lib/awscc/k3s/securitygroups.tf

resource "awscc_ec2_security_group" "any_any_allow" {
  group_name        = local.cluster_name
  group_description = "All traffic is accepted"
  vpc_id            = var.vpc_id

  tags = [
    {
      key   = "Name"
      value = local.cluster_name
    }
  ]
}

resource "awscc_ec2_security_group_ingress" "any_allow_in" {
  group_id    = awscc_ec2_security_group.any_any_allow.id
  ip_protocol = "-1"
  from_port   = -1
  to_port     = -1

  cidr_ip     = "0.0.0.0/0"            # ← use cidr_ip, not cidr_blocks
  description = "All input is accepted"
}

resource "awscc_ec2_security_group_egress" "any_allow_out" {
  group_id    = awscc_ec2_security_group.any_any_allow.id
  ip_protocol = "-1"
  from_port   = -1
  to_port     = -1

  cidr_ip     = "0.0.0.0/0"            # ← use cidr_ip here as well
  description = "All output is accepted"
}


# resource "aws_security_group" "egress" {
#     name        = "${local.cluster_name}-egress"
#     description = "All output is accepted"
#     vpc_id      = var.vpc_id
#     tags        = local.tags
#     egress {
#         cidr_blocks = ["0.0.0.0/0"]
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         description = "All output is accepted"
#     }
# }

# resource "aws_security_group" "ingress_internal" {
#     name        = "${local.cluster_name}-ingress-internal"
#     description = "All input from nodes and pods in the cluster is accepted"
#     vpc_id      = var.vpc_id
#     tags        = local.tags
#     ingress {
#         protocol    = -1
#         from_port   = 0
#         to_port     = 0
#         self        = true
#         description = "Accept input from nodes"
#     }
#     ingress {
#         protocol    = -1
#         from_port   = 0
#         to_port     = 0
#         cidr_blocks = [ "${var.networking["pod_network_block"]}" ] 
#         description = "Accept input from pods"
#     }
# }

# resource "aws_security_group" "ingress_ssh" {
#     name        = "${local.cluster_name}-ssh"
#     description = "Accept input ssh from allowed hosts"
#     vpc_id      = var.vpc_id
#     tags        = local.tags
#     ingress {
#         cidr_blocks = [ "${var.networking["allowed_ssh_access_hosts_cidr"]}" ]
#         from_port   = 22
#         to_port     =  22
#         protocol    = "tcp"
#         description = "Accept input ssh from allowed hosts"
#     }
# }

# resource "aws_security_group" "ingress_kubeapi" {
#     name        = "${local.cluster_name}-ingress-k8s"
#     description = "Accept input kube api tcp/6443 from allowed hosts"
#     vpc_id      = var.vpc_id
#     tags        = local.tags
#     ingress {
#         protocol    = "tcp"
#         from_port   = 6443
#         to_port     = 6443
#         cidr_blocks = [ "${var.networking["allowed_kubeapi_cidr"]}" ]
#         description = "Accept tcp/6443 from allowed hosts"
#     }
# }

# resource "aws_security_group" "ingress_controller_80" {
#     name        = "${local.cluster_name}-ingress-80"
#     description = "Accept input for ingress controller on port 80"
#     vpc_id      = var.vpc_id
#     tags        = local.tags
#     ingress {
#         protocol    = "tcp"
#         from_port   = 80
#         to_port     = 80
#         cidr_blocks = [ "${var.networking["allowed_kubeapi_cidr"]}" ]
#         description = "Accept tcp/80 from allowed hosts"
#     }
# }

# resource "aws_security_group" "ingress_controller_443" {
#     name        = "${local.cluster_name}-ingress-443"
#     description = "Accept input for ingress controller on port 443"
#     vpc_id      = var.vpc_id
#     tags        = local.tags
#     ingress {
#         protocol    = "tcp"
#         from_port   = 443
#         to_port     = 443
#         cidr_blocks = [ "${var.networking["allowed_kubeapi_cidr"]}" ]
#         description = "Accept tcp/443 from allowed hosts"
#     }
# }