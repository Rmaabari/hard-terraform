variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}
variable "kubernetes_version" {
  description = "Kubernetes version for the EKS control plane"
  type        = string
  default     = "1.27"
}
variable "vpc_id" {
  description = "VPC ID where EKS will be deployed"
  type        = string
}
variable "subnet_ids" {
  description = "List of subnet IDs for the EKS control plane and nodes"
  type        = list(string)
}
variable "key_name" {
  description = "SSH key pair name for node SSH access"
  type        = string
}
variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
  default     = "worker-group"
}
variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}
variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}
variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}
variable "instance_types" {
  description = "EC2 instance types for worker nodes"
  type        = list(string)
  default     = ["t3.medium"]
}


variable "role_arn" {
  type        = string
  description = "ARN of an existing IAM role for EKS control plane"
}