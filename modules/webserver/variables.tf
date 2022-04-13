variable "cluster_name" {
  type        = string
  description = "The name of the cluster - comes from main.tf"
}
variable "eks_subnet_ids" {
  type        = list(string)
  description = "The subnet ids for the EKS cluster - comes from main.tf"
}