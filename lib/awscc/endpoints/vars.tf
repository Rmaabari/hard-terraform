variable "vpc_id" {
  description = "VPC ID for the endpoint"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the endpoint"
  type        = list(string)
}

variable "private_dns_enabled" {
  description = "Enable private DNS for the endpoint"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to the VPC endpoint"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "AWS region for the VPC endpoint"
  type        = string
}

variable "route_table_ids" {
  description = "List of route table IDs for gateway endpoints (e.g. S3)"
  type        = list(string)
}