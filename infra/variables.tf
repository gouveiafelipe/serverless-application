variable "service_name" {
  type        = string
  description = "service name"
  default     = "Teemo Application"
}

variable "service_domain" {
  type        = string
  description = ""
  default     = "api-teemo"
}

variable "aws_region" {
  type        = string
  description = ""
  default     = "sa-east-1"
}

variable "aws_account_id" {
  type        = number
  description = ""
  default     = 971972083514
}