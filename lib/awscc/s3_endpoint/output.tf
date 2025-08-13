output "s3_endpoint_service_name" {
  description = "The service name that backs this endpoint"
  value       = awscc_ec2_vpc_endpoint.s3.service_name
}