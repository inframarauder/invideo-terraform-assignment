output "test_policy_arn" {
  value = aws_iam_role.test_oidc.arn
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.invideo_cluster.endpoint
}