variable "lab_name" {
  type = string
}

variable "anti_virus_sqs" {
  description = "Whether to create SQS queues for anti-virus integrations"
  type        = bool
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}