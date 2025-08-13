output "aws_policy" {
  value       = aws_iam_policy.aws_ec2_engines.name
}

output "aws_role_name" {
  value       = awscc_iam_role.engines_role.role_name
}

output "aws_instance_profile_name" {
  value       = aws_iam_instance_profile.engines_instance_profile.name
}