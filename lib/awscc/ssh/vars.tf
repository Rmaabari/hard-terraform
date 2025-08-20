variable "ssh_key_name" {
    type        = string
    description = "name for the created key"
}

variable "public_key_file_path" {
    type        = string
    description = "ssh key file for access cluster nodes on local pc"
    default     = "~/.ssh/id_rsa.pub"
}

variable "tags" {
  type        = map(string)
  description = "A set of tags to assign to the created AWS resources."
  default     = {}
}
