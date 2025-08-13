resource "awscc_ec2_subnet" "core_priv_subnet" {
    vpc_id     = awscc_ec2_vpc.main.id
    cidr_block = var.core_priv_subnet["cidr_block"]
    tags = [
      {
        key   = "Name"
        value = var.core_priv_subnet["tag"]
      }
    ]
}

# resource "aws_ec2_subnet_cidr_reservation" "core_priv_subnet_reserved_block" {
#     description      = "these ips reserved for static use. For example: secondary ip for vrrp"
#     cidr_block       = var.core_priv_subnet["cidr_reserved_block"]
#     subnet_id        = awscc_ec2_subnet.core_priv_subnet.id
#     reservation_type = "prefix"
# }

### EFS

# : OFFLINE ONLY add vpc peer offline ==== test
resource "aws_vpc_peering_connection" "vpc_peering" {
    count       = try(var.core_priv_subnet["efs_peer"] == "enabled", false) ? 1 : 0
    peer_vpc_id = var.core_priv_subnet["efs_peer_vpc_id"]
    vpc_id      = awscc_ec2_vpc.main.id 
    tags        = { Name = "${var.core_priv_subnet["tag"]}_efs_offline_test"}
}

# : OFFLINE_ONLY security rules
resource "aws_security_group_rule" "allow_efs_in" {
  count       = try(var.core_priv_subnet["efs_peer"] == "enabled", false) ? 1 : 0
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  security_group_id = var.core_priv_subnet["efs_control_sg"] 

  source_security_group_id = var.core_priv_subnet["efs_mount_sg"]
}

resource "aws_security_group_rule" "allow_efs_out" {
  count       = try(var.core_priv_subnet["efs_peer"] == "enabled", false) ? 1 : 0
  type              = "egress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  security_group_id = var.core_priv_subnet["efs_control_sg"] 

  source_security_group_id = var.core_priv_subnet["efs_mount_sg"]  
}

# : OFFLINE ONLY accept vpc
resource "aws_vpc_peering_connection_accepter" "accepter" {
    count                   = try(var.core_priv_subnet["efs_peer"] == "enabled", false) ? 1 : 0
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[0].id
    auto_accept             = true

    tags = {
        Name = "${var.core_priv_subnet["tag"]}_efs_offline_test"
    }
}


# : add routes
locals {
  vpc_peering_conn_priv_id = try(var.core_priv_subnet["efs_peer"] == "enabled", false) ? aws_vpc_peering_connection.vpc_peering[0].id : (can(var.core_priv_subnet["extra_route_vpc_con_id"]) ? var.core_priv_subnet["extra_route_vpc_con_id"] : null)
}

locals {
  core_extra_route = try(var.core_priv_subnet["extra_route_cidr"], null)
}

locals {
  routes = {
    internet = {
      enabled                   = try(var.core_priv_subnet["internet"] == "enabled", false)
      cidr_block                = "0.0.0.0/0"
      nat_gateway_id            = awscc_ec2_nat_gateway.nat_gw.id
      vpc_peering_connection_id = null
    },
    extra_route = {
      enabled                   = try(var.core_priv_subnet["extra_route"] == "enabled", false)
      cidr_block                = local.core_extra_route
      nat_gateway_id            = null
      vpc_peering_connection_id = local.vpc_peering_conn_priv_id
    }
  }
}

# Create the route table.
resource "awscc_ec2_route_table" "core_rt" {
  vpc_id = awscc_ec2_vpc.main.id

  # Tags must be provided as a list of objects.
  tags = [
    {
      key   = "Name"
      value = "${var.engines_priv_subnet.tag}"
    }
  ]
}

# Create routes as separate resources.
resource "awscc_ec2_route" "core_routes" {
  for_each = { for k, v in local.routes : k => v if v.enabled }

  route_table_id            = awscc_ec2_route_table.core_rt.id
  destination_cidr_block    = each.value.cidr_block
  nat_gateway_id            = each.value.nat_gateway_id
  vpc_peering_connection_id = each.value.vpc_peering_connection_id
}

# Associate the route table with the subnet.
resource "awscc_ec2_subnet_route_table_association" "core_rta" {
  subnet_id      = awscc_ec2_subnet.core_priv_subnet.id
  route_table_id = awscc_ec2_route_table.core_rt.id
}