variable "vpc_id" {
  description = "ID of the VPC where we’ll make the S3 endpoint"
  type        = string
}

variable "route_table_ids" {
  description = "List of RTB IDs to associate the S3 endpoint with"
  type        = list(string)
}

variable "tags" {
  description = "Optional tags to apply (map of key→value)"
  type        = map(string)
  default     = {}
}
