output "vpc_id" {
  value       = aws_vpc.invideo_vpc.id
  description = "Value of the VPC ID created"
}
output "db_subnet_ids" {
  value       = [aws_subnet.db_subnet_1.id, aws_subnet.db_subnet_2.id]
  description = "DB private subnet ids"
}

output "eks_subnet_ids" {
  value       = [aws_subnet.eks_private_1.id, aws_subnet.eks_private_2.id, aws_subnet.eks_public_1.id, aws_subnet.eks_public_2.id]
  description = "EKS private subnet ids"
}

output "node_subnet_ids" {
  value       = [aws_subnet.eks_private_1.id, aws_subnet.eks_private_2.id]
  description = "EKS private subnet ids"
}