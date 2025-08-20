output "ssh_key_name" {
  value       = awscc_ec2_key_pair.main.key_name
  description = "Name of the created ssh key on aws"
}

output "public_key_file_path" {
  value       = var.public_key_file_path
  description = "Name of the created ssh key on aws"
}
