variable "image_id" {
  description = "The AMI ID to launch"
  type        = string
}

variable "instance_type" {
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
}

variable "volume_size" {
  description = "Size (GiB) of the root EBS volume"
  type        = string
}

variable "tags" {
    type = map(string)
    default = {}
}

variable "public_key_file_path" {
    type        = string
    description = "ssh pubkey file for access cluster nodes on local pc"
}

variable "private_key_file_path" {
    type        = string
    description = "ssh key file for access cluster nodes on local pc"
}

variable "oxy_carrier_replicas" {
  type        = number
  description = "Replicas controlling static/dynamic IP in the bastion host"
  default     = 0
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