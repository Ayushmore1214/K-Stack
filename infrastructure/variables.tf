variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "A unique name for the project to prefix resources."
  type        = string
  default     = "todo-app"
}

variable "db_username" {
  description = "Database master username."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database master password."
  type        = string
  sensitive   = true
}