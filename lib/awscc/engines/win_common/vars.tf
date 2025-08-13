variable "ami" {
    type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "networking" {
  type        = map(string)
}

variable "tags" {
    type = map(string)
    default = {}
}

variable "disk_size" {
  type        = string
}

variable "eng_name" {
  type        = string
}

variable "replicas" {
  type        = number
  description = "replicas"
}

variable "public_key_file_path" {
    type        = string
    description = "ssh pubkey file for access this vm on local pc"
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