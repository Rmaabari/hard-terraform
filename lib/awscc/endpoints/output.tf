output "vpc_endpoint_id" {
  description = "The ID of the VPC endpoint"
  value       = awscc_ec2_vpc_endpoint.ec2.id
}

output "vpc_endpoint_dns_entries" {
  description = "The DNS entries for the VPC endpoint"
  value       = awscc_ec2_vpc_endpoint.ec2.dns_entries
}