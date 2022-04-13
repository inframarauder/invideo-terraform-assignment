#creating the EKS Cluster:
resource "aws_eks_cluster" "invideo_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_iam_role.arn

  vpc_config {
    subnet_ids = var.eks_subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_iam_policy_attachment,
  ]

  tags = {
    "Project" = "invideo"
  }
}

