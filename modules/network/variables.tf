variable "db_subnet_1_az" {
  type        = string
  description = "The availability zone for the first DB private subnet"
}

variable "db_subnet_2_az" {
  type        = string
  description = "The availability zone for the second DB private subnet"
}

variable "eks_public_1_az" {
  type        = string
  description = "The availability zone for the first EKS public subnet"
}

variable "eks_public_2_az" {
  type        = string
  description = "The availability zone for the second EKS public subnet"
}

variable "eks_private_1_az" {
  type        = string
  description = "The availability zone for the first EKS private subnet"
}

variable "eks_private_2_az" {
  type        = string
  description = "The availability zone for the second EKS public subnet"
}

variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster"
}