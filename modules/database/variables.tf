variable "vpc_id" {
  type        = string
  description = "Value of the VPC ID inside which RDS shall be created"
}

variable "db_subnet_ids" {
  type        = list(string)
  description = "The subnet ids for the database - comes from newtorking module"
}

variable "username" {
  type        = string
  description = "The username for the database - comes from main.tf"
}

variable "password" {
  type        = string
  description = "The password for the database - comes from main.tf"
}

