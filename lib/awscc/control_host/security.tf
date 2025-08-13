resource "awscc_ec2_security_group" "control_host" {
  group_name        = "lnx control_host rules"
  group_description = "File Metadata SG Rules"
  vpc_id            = var.vpc_id

  tags = [
    for k, v in merge(
      var.tags,
      { Name = "Control-Host" }
    ) : {
      key   = k
      value = v
    }
  ]
}

resource "awscc_ec2_security_group_ingress" "ssh_incoming" {
  group_id    = awscc_ec2_security_group.control_host.id
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_ip     = var.networking["allowed_ssh_access_hosts_cidr"]
  description = "Incoming SSH"
}

resource "awscc_ec2_security_group_ingress" "local_adaptor" {
  group_id    = awscc_ec2_security_group.control_host.id
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_ip     = var.networking["allowed_ssh_access_hosts_cidr"]
  description = "Incoming SSH"
}

resource "awscc_ec2_security_group_ingress" "docker_registry" {
  group_id    = awscc_ec2_security_group.control_host.id
  ip_protocol = "tcp"
  from_port   = 5000
  to_port     = 5000
  cidr_ip     = var.networking["allowed_ssh_access_hosts_cidr"]
  description = "Docker Registry"
}

resource "awscc_ec2_security_group_egress" "https_out" {
  group_id    = awscc_ec2_security_group.control_host.id
  ip_protocol = "-1"
  from_port   = -1
  to_port     = -1
  cidr_ip     = "0.0.0.0/0"
  description = "All output is accepted"
}