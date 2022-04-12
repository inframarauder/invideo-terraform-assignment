variable "region" {
  type        = string
  description = "The AWS region to use."
  default     = "ap-south-1"
}

variable "db_username" {
  type        = string
  description = "The username for the database - comes from terraform.tfvars"
}

variable "db_password" {
  type        = string
  description = "The password for the database - comes from terraform.tfvars"
  sensitive   = true
}

variable "db_subnet_1_az" {
  type        = string
  description = "The availability zone for the first DB private subnet"
  default     = "ap-south-1b"
}

variable "db_subnet_2_az" {
  type        = string
  description = "The availability zone for the second DB private subnet"
  default     = "ap-south-1c"
}