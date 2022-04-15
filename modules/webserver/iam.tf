#creating the required IAM Role and attaching the IAM Policy for EKS:
resource "aws_iam_role" "eks_iam_role" {
  name = "eks-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  tags = {
    "Project" = "invideo"
  }
}

resource "aws_iam_role_policy_attachment" "eks_iam_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" #AWS Managed Policy
  role       = aws_iam_role.eks_iam_role.name

}

#creating the IAM Role for node group nodes and attaching the IAM Policies for EKS Worker Nodes:
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
  tags = {
    "Project" = "invideo"
  }
}

resource "aws_iam_role_policy_attachment" "worker_node_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" #AWS Managed Policy
  role       = aws_iam_role.eks_node_role.name

}

resource "aws_iam_role_policy_attachment" "cni_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy" #AWS Managed Policy
  role       = aws_iam_role.eks_node_role.name

}

resource "aws_iam_role_policy_attachment" "ecr_readonly_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" #AWS Managed Policy
  role       = aws_iam_role.eks_node_role.name

}

#creating IAM OIDC provider for service account to manager permission for EKS cluster:
data "tls_certificate" "eks_cert" {
  url = aws_eks_cluster.invideo_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks_openid_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_cert.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.invideo_cluster.identity[0].oidc[0].issuer
}


#creating an IAM role with s3 bucket list and get bucket permissons:
#just a test for the OIDC provider
data "aws_iam_policy_document" "test_oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_openid_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:aws-service-account"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_openid_provider.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "test_oidc" {
  assume_role_policy = data.aws_iam_policy_document.test_oidc_assume_role_policy.json
  name               = "test-oidc"
}

resource "aws_iam_policy" "test_policy" {
  name = "test-policy"

  policy = jsonencode({
    Statement = [{
      Action = [
        "s3:ListAllMyBuckets",
      ]
      Effect   = "Allow"
      Resource = "arn:aws:s3:::*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "test_attach" {
  role       = aws_iam_role.test_oidc.name
  policy_arn = aws_iam_policy.test_policy.arn
}




