variable "cluster_name" {
  type        = string
  description = "The name of the cluster - comes from main.tf"
}
variable "eks_subnet_ids" {
  type        = list(string)
  description = "The subnet ids for the EKS cluster - comes from main.tf"
}
variable "node_subnet_ids" {
  type        = list(string)
  description = "The private subnet ids for the node group - comes from main.tf"
}