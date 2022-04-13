#creating the private EKS Node Group:
resource "aws_eks_node_group" "private_node_group" {
  cluster_name    = aws_eks_cluster.invideo_cluster.name
  node_group_name = "private-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  subnet_ids = var.node_subnet_ids #must be private subnets of the EKS Cluster

  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium"]
  disk_size      = 8

  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 1
  }

  update_config {
    max_unavailable = 2
  }

  labels = {
    app = "invideo"
  }

  depends_on = [
    aws_iam_role_attachment.worker_node_policy_attachment,
    aws_iam_policy_attachment.cni_policy_attachment,
    aws_iam_policy_attachment.ecr_readonly_policy_attachment
  ]

  tags = {
    "Project" = "invideo"
  }
}