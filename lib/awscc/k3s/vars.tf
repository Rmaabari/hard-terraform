variable "cluster_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "ssh_key_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "networking" {
  type        = map(string)
  description = "ip addresses used in k3s cluster"
}

variable "replicas" {
  type        = map(number)
  description = "replicas of k3s nodes"
}

variable "amis" {
  type        = map(string)
  description = "ami for k3s cluster nodes"
}

variable "instance_types" {
  type        = map(string)
  description = "ec2 instance sizes of k3s cluster nodes"
}

variable "disk_sizes" {
  type        = map(number)
  description = "ec2 disk sizes of k3s cluster nodes"
}

variable "tags" {
    type = map(string)
    default = {}
}

variable "lab_name" {
  type = string
}

variable "ebs_csi_policy_arn" {
  description = "ARN of the EBS CSI IAM policy to attach"
  type        = string
}

variable "device_name" {
  description = "The device name exposed to the instance (e.g. /dev/sda1)"
  type        = string
  default     = "/dev/sda1"
}

variable "volume_type" {
  description = "EBS volume type for the root device"
  type        = string
  default     = "gp3"
}