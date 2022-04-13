#creating the required IAM Role and Policy for EKS:
resource "aws_iam_role" "eks_iam_role" {
  name = "eks-service-role"
  assume_role_policy = <<POLICY
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Action": "sts:AssumeRole",
              "Principal": {
                  "Service": "eks.amazonaws.com"
              },
              "Effect": "Allow",
          }
      ]

  }
  POLICY
}

resource "aws_iam_policy" "eks_iam_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy" #attach the managed IAM Policy -  AamazonEKSServicePolicy to the IAM Role
  role       = aws_iam_role.eks_iam_role.name
}