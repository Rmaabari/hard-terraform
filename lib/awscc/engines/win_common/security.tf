resource "awscc_ec2_security_group" "main_win" {
  group_name        = "windows-security-${var.eng_name}"
  group_description = "windows security rules"
  vpc_id            = var.vpc_id
  tags = [
    for k, v in merge(
      var.tags,
      { Name = "${var.eng_name}" }
    ) : {
      key   = k
      value = v
    }
  ]
}

resource "awscc_ec2_security_group_ingress" "ssh_incoming" {
  group_id    = awscc_ec2_security_group.main_win.id
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_ip     = var.networking["allowed_ssh_access_hosts_cidr"]
  description = "Incoming SSH"
}

resource "awscc_ec2_security_group_ingress" "rdp_incoming" {
  group_id    = awscc_ec2_security_group.main_win.id
  ip_protocol = "tcp"
  from_port   = 3389
  to_port     = 3389
  cidr_ip     = var.networking["allowed_ssh_access_hosts_cidr"]
  description = "Incoming RDP"
}

resource "awscc_ec2_security_group_ingress" "allow_all_vpc" {
  group_id    = awscc_ec2_security_group.main_win.id
  ip_protocol = "-1"
  from_port   = -1
  to_port     = -1
  cidr_ip     = "10.0.0.0/8"
  description = "allow all VPC traffic"
}

resource "awscc_ec2_security_group_ingress" "local_adaptor" {
  group_id    = awscc_ec2_security_group.main_win.id
  ip_protocol = var.networking["app_ingress_proto"]
  from_port   = var.networking["app_ingress_port"]
  to_port     = var.networking["app_ingress_port"]
  cidr_ip     = var.networking["app_ingress_block"]
  description = "Local Adaptor"
}

resource "awscc_ec2_security_group_egress" "https_out" {
  group_id    = awscc_ec2_security_group.main_win.id
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_ip     = var.networking["app_ingress_block"]
  description = "All output is accepted"
}


# #@####################
# resource "aws_security_group" "main" {
#     name    = "${var.eng_name}"
#     vpc_id  = var.vpc_id
#     # remove(or change to limit) in production env
#     ingress {
#         cidr_blocks = [ "${var.networking["allowed_ssh_access_hosts_cidr"]}" ]
#         from_port = 22
#         to_port  =  22
#         protocol = "tcp"
#     }

#     # remove(or change to limit) in production env
#     ingress {
#         cidr_blocks = [ "${var.networking["allowed_rdp_access_hosts_cidr"]}" ]
#         from_port = 3389
#         to_port  =  3389
#         protocol = "tcp"
#     }

#     ingress {
#         cidr_blocks = [ "${var.networking["app_ingress_block"]}" ]
#         from_port = "${var.networking["app_ingress_port"]}"
#         to_port  =  "${var.networking["app_ingress_port"]}"
#         protocol = "${var.networking["app_ingress_proto"]}"
#     }
#     # allow all VPC traffic
#     ingress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["10.0.0.0/8"]
#     }


#     // remove the default rule
#     egress {
#         cidr_blocks = [ "${var.networking["app_ingress_block"]}" ]
#         from_port = 443
#         to_port   = 443
#         protocol  = "tcp"
#     }

#     tags                        = var.tags
# }