variable "ami" {
    type = string
}

variable "lab_name" {
  type = string
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

variable "disk_size" {
  type        = number
  default     = 300
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

variable "replicas" {
  type        = number
  description = "replicas"
}

variable "device_name" {
  description = "The device name exposed to the instance (e.g. /dev/sda1)"
  type        = string
  default     = "/dev/sda1"
}

variable "volume_type" {
  description = "EBS volume type for the root device"
  type        = string
  default     = "gp2"
}