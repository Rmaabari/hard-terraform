resource "awscc_ec2_security_group" "oxy_carrier" {
  group_name        = "oxy carrier rules"
  group_description = "Oxy-Carrier SG Rules"
  vpc_id            = var.vpc_id

  tags = [
    {
      key   = "Name"
      value = "oxy-carrier"
    }
  ]
}

resource "awscc_ec2_security_group_ingress" "ssh_incoming" {
  group_id    = awscc_ec2_security_group.oxy_carrier.id
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_ip     = var.networking["allowed_ssh_access_hosts_cidr"]
  description = "Incoming SSH"
}

resource "awscc_ec2_security_group_egress" "ssh_out" {
  group_id    = awscc_ec2_security_group.oxy_carrier.id
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_ip     = var.networking["allowed_ssh_access_hosts_cidr"]
  description = "SSH Out"
}
