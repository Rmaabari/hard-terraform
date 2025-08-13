# ─────────────────────────────────────────────────────────────────────────────
# 1️⃣  The SG itself only has egress
resource "awscc_ec2_security_group" "main" {
  group_name        = "bastion_host_rules"
  group_description = "Allow SSH, VPN, NFS, Syslog, APT-Cacher"
  vpc_id            = var.vpc_id

  tags = [
    for k, v in merge(
      var.tags,
      { Name = "Bastion" }
    ) : {
      key   = k
      value = v
    }
  ]

  security_group_egress = [{
    description = "All outbound IPv4"
    ip_protocol = "-1"
    from_port   = -1
    to_port     = -1
    cidr_ip     = "0.0.0.0/0"
  }]

  lifecycle {
    ignore_changes = [
      security_group_egress,
      tags
    ]
  }

}

# ─────────────────────────────────────────────────────────────────────────────
# 2️⃣  SSH from IPv4
resource "awscc_ec2_security_group_ingress" "ssh" {
  group_id    = awscc_ec2_security_group.main.id
  description = "SSH from allowed hosts"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_ip     = var.networking["allowed_ssh_access_hosts_cidr"]
}

# ─────────────────────────────────────────────────────────────────────────────
# 3️⃣  VPN (UDP)
resource "awscc_ec2_security_group_ingress" "vpn_udp" {
  group_id    = awscc_ec2_security_group.main.id
  description = "Bastion VPN"
  ip_protocol = "udp"
  from_port   = tonumber(var.networking["bastion_vpn_port"])
  to_port     = tonumber(var.networking["bastion_vpn_port"])
  cidr_ip     = var.networking["allowed_ssh_access_hosts_cidr"]
}

# ─────────────────────────────────────────────────────────────────────────────
# 4️⃣  NFS v4 (2049/tcp)
resource "awscc_ec2_security_group_ingress" "nfs_v4" {
  group_id    = awscc_ec2_security_group.main.id
  description = "NFSv4 data"
  ip_protocol = "tcp"
  from_port   = 2049
  to_port     = 2049
  cidr_ip     = var.networking["allowed_nfs_access_hosts_cidr"]
}

# ─────────────────────────────────────────────────────────────────────────────
# 5️⃣  NFS RPCbind (portmap, 111/tcp)
resource "awscc_ec2_security_group_ingress" "nfs_rpcbind" {
  group_id    = awscc_ec2_security_group.main.id
  description = "RPCbind (mountd/portmapper)"
  ip_protocol = "tcp"
  from_port   = 111
  to_port     = 111
  cidr_ip     = var.networking["allowed_nfs_access_hosts_cidr"]
}

# ─────────────────────────────────────────────────────────────────────────────
# 6️⃣  Syslog over UDP (514/udp)
resource "awscc_ec2_security_group_ingress" "syslog_udp" {
  group_id    = awscc_ec2_security_group.main.id
  description = "Remote syslog"
  ip_protocol = "udp"
  from_port   = 514
  to_port     = 514
  cidr_ip     = var.networking["allowed_nfs_access_hosts_cidr"]
}

# ─────────────────────────────────────────────────────────────────────────────
# 7️⃣  Syslog over TCP (514/tcp)
resource "awscc_ec2_security_group_ingress" "syslog_tcp" {
  group_id    = awscc_ec2_security_group.main.id
  description = "Remote syslog"
  ip_protocol = "tcp"
  from_port   = 514
  to_port     = 514
  cidr_ip     = var.networking["allowed_nfs_access_hosts_cidr"]
}

# ─────────────────────────────────────────────────────────────────────────────
# 8️⃣  APT-Cacher-NG proxy (3142/tcp)
resource "awscc_ec2_security_group_ingress" "apt_cacher" {
  group_id    = awscc_ec2_security_group.main.id
  description = "APT-Cacher-NG proxy"
  ip_protocol = "tcp"
  from_port   = 3142
  to_port     = 3142
  cidr_ip     = var.networking["allowed_nfs_access_hosts_cidr"]
}

# ─────────────────────────────────────────────────────────────────────────────
# 9️⃣  Additional NFS helper port (33400/tcp)
resource "awscc_ec2_security_group_ingress" "nfs_port_33400" {
  group_id    = awscc_ec2_security_group.main.id
  description = "NFS helper"
  ip_protocol = "tcp"
  from_port   = 33400
  to_port     = 33400
  cidr_ip     = var.networking["allowed_nfs_access_hosts_cidr"]
}