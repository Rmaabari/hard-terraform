resource "awscc_ec2_security_group" "archive_extractor" {
  group_name        = "lnx internal_extractor rules"
  group_description = "Internal Extractor SG Rules"
  vpc_id            = var.vpc_id

  tags = [
    for k, v in merge(
      var.tags,
      { Name = "ArchvieExtractor" }
    ) : {
      key   = k
      value = v
    }
  ]
}

resource "awscc_ec2_security_group_ingress" "ssh_incoming" {
  group_id    = awscc_ec2_security_group.archive_extractor.id
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_ip     = var.networking["allowed_ssh_access_hosts_cidr"]
  description = "Incoming SSH"
}

resource "awscc_ec2_security_group_ingress" "local_adaptor" {
  group_id    = awscc_ec2_security_group.archive_extractor.id
  ip_protocol = var.networking["app_ingress_proto"]
  from_port   = var.networking["app_ingress_port"]
  to_port     = var.networking["app_ingress_port"]
  cidr_ip     = var.networking["app_ingress_block"]
  description = "Local Adaptor"
}

resource "awscc_ec2_security_group_egress" "https_out" {
  group_id    = awscc_ec2_security_group.archive_extractor.id
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_ip     = var.networking["app_ingress_block"]
  description = "All output is accepted"
}