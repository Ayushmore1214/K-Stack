variable "region" {
  description = "AWS region for deployment."
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "domain_name" {
  description = "Optional: domain name for app."
  type        = string
  default     = ""
}