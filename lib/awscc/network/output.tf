# VPC
output "vpc_id" {
  value = awscc_ec2_vpc.main.id
}

output "vpc_block" {
  value = awscc_ec2_vpc.main.cidr_block
}

# ENTRY
output "entry_pub_subnet_id" {
  value = awscc_ec2_subnet.entry_pub_subnet.id
}

output "entry_pub_subnet_block" {
  value = var.entry_pub_subnet["cidr_block"]
}

output "entry_pub_subnet_reserved_block" {
  value = var.entry_pub_subnet["cidr_reserved_block"]
}

output "entry_pub_subnet_route_table_id" {
  value = awscc_ec2_route_table.entry_inet_rt.id
}

output "engines_priv_subnet_id" {
  value = awscc_ec2_subnet.engines_priv_subnet.id
}

output "engines_priv_subnet_block" {
  value = var.engines_priv_subnet["cidr_block"]
}

output "engines_priv_subnet_route_table_id" {
  value = awscc_ec2_route_table.engines_priv_rt.id
}

output "engines_priv_subnet_offline_status" {
  value = var.engines_priv_subnet["internet"] == "enabled" ? true : false
}

# CORE
output "core_priv_subnet_id" {
  value = awscc_ec2_subnet.core_priv_subnet.id
}

output "core_priv_subnet_block" {
  value = var.core_priv_subnet["cidr_block"]
}

output "core_priv_subnet_reserved_block" {
  value = var.core_priv_subnet["cidr_reserved_block"]
}

output "core_priv_subnet_route_table_id" {
  value = awscc_ec2_route_table.core_rt.id
}

output "core_priv_subnet_offline_status" {
  value = var.core_priv_subnet["internet"] == "enabled" ? true : false
}
