variable "profile_name" {
  type = string
}

variable "role_name" {
  type = string
}

variable "tags" {
    type = map(string)
    default = {}
}

variable "subnet_id" {
  type = string
}

variable "lab_name" {
  type = string
}