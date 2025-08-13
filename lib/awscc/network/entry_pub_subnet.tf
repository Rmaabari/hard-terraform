# entry_pub_subnet.tf

resource "awscc_ec2_subnet" "entry_pub_subnet" {
  vpc_id                  = awscc_ec2_vpc.main.id
  cidr_block              = var.entry_pub_subnet["cidr_block"]
  map_public_ip_on_launch = true

  tags = [
    { key = "Name", value = var.entry_pub_subnet["tag"] },
  ]
}

# resource "aws_ec2_subnet_cidr_reservation" "entry_pub_subnet_reserved_block" {
#   description      = "IPs reserved for static use (e.g. VRRP)"
#   cidr_block       = var.entry_pub_subnet["cidr_reserved_block"]
#   subnet_id        = awscc_ec2_subnet.entry_pub_subnet.id
#   reservation_type = "prefix"
# }

locals {
  vpc_peering_conn_entry_id = (
    lookup(var.entry_pub_subnet, "efs_peer", "") == "enabled"
      ? aws_vpc_peering_connection.vpc_peering[0].id
      : lookup(var.entry_pub_subnet, "extra_route_vpc_con_id", null)
  )

  extra_routes = {
    to_offline_control_host = {
      enabled                   = lookup(var.entry_pub_subnet, "extra_route", "") == "enabled"
      cidr_block                = lookup(var.entry_pub_subnet, "extra_route_cidr", null)
      vpc_peering_connection_id = local.vpc_peering_conn_entry_id
    }
  }
}

resource "awscc_ec2_route_table" "entry_inet_rt" {
  vpc_id = awscc_ec2_vpc.main.id

  tags = [
    { key = "Name", value = "${var.entry_pub_subnet["tag"]}-rt" },
  ]
}

resource "awscc_ec2_route" "entry_internet" {
  route_table_id         = awscc_ec2_route_table.entry_inet_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = awscc_ec2_internet_gateway.gw.id

  depends_on = [ awscc_ec2_vpc_gateway_attachment.gw_attachment ]
}

resource "awscc_ec2_route" "efs_peer" {
  count = lookup(var.entry_pub_subnet, "efs_peer", "") == "enabled" ? 1 : 0

  route_table_id            = awscc_ec2_route_table.entry_inet_rt.id
  destination_cidr_block    = lookup(var.entry_pub_subnet, "extra_route_cidr", null)
  vpc_peering_connection_id = local.vpc_peering_conn_entry_id
}

resource "awscc_ec2_route" "nic" {
  count                  = var.oxy_carrier_replicas == 1 ? 1 : 0
  route_table_id         = awscc_ec2_route_table.entry_inet_rt.id
  destination_cidr_block = "10.100.100.0/24"
  network_interface_id   = var.oxy_carrier_network_interface_id
}

resource "awscc_ec2_route" "extra" {
  for_each = {
    for name, r in local.extra_routes : name => r
    if r.enabled
  }

  route_table_id            = awscc_ec2_route_table.entry_inet_rt.id
  destination_cidr_block    = each.value.cidr_block
  vpc_peering_connection_id = each.value.vpc_peering_connection_id
}

resource "awscc_ec2_subnet_route_table_association" "entry_rta" {
  subnet_id      = awscc_ec2_subnet.entry_pub_subnet.id
  route_table_id = awscc_ec2_route_table.entry_inet_rt.id
}