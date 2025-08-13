variable "ami" {
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

variable "instance_profile" {
  type        = string
}

variable "disk_size" {
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

variable "replicas" {
  type        = number
  description = "replicas"
}