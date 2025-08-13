variable "enable_vpc_dnsnames" {
  type        = bool
  description = "enable dns hostnames for the vpc"
  default     = false
}

variable "cidr_vpc_block" {
  type        = string
  description = "ip block for vpc"
}

variable "entry_pub_subnet" {
  type        = map(string)
  description = "pub subnet for vpn. required keys: cidr_block, cidr_reserved_block."
}

variable "engines_pub_subnet" {
  type        = map(string)
  description = "pub subnet for engines.required keys: cidr_block, cidr_reserved_block."
}

variable "engines_priv_subnet" {
  type        = map(string)
  description = "priv subnet for engines.required keys: cidr_block, cidr_reserved_block."
}

variable "core_priv_subnet" {
  type        = map(string)
  description = "priv subnet for core. required keys: cidr_block, cidr_reserved_block."
}

variable "cpe_priv_subnet" {
  type        = map(string)
  description = "priv subnet for cpe. required keys: cidr_block, cidr_reserved_block."
  default = {}
}

variable "vpc_tags" {
    type        = map(string)
    description = "Tags to assign to the created resources"
    default     = {}
}

variable "oxy_carrier_replicas" {
  type        = number
  description = "The number of oxy carrier replicas."
}

variable "oxy_carrier_network_interface_id" {
  type        = string
  description = "The network interface ID for the oxy_carrier instance."
}