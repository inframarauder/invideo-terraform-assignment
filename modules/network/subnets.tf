
#creating two private subnets for DB as per requirements of RDS:
resource "aws_subnet" "db_subnet_1" {
  vpc_id            = aws_vpc.invideo_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.db_subnet_1_az

  tags = {
    "Name"    = "private_db_1"
    "Project" = "invideo"
  }
}

resource "aws_subnet" "db_subnet_2" {
  vpc_id            = aws_vpc.invideo_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.db_subnet_2_az


  tags = {
    "Name"    = "private_db_2"
    "Project" = "invideo"
  }
}


#creating two public subnets as per requirements of EKS:
resource "aws_subnet" "eks_public_1" {
  vpc_id            = aws_vpc.invideo_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.eks_public_1_az

  tags = {
    "Name"                                      = "eks_public_1"
    "Project"                                   = "invideo"
    "kubernetes.io/role/elb"                    = "1"      #required tag by EKS to identify public subnet for load balancer
    "kubernetes.io/cluster/${var.cluster_name}" = "shared" #required tag by EKS to identify public subnet for load balancer
  }
}

resource "aws_subnet" "eks_public_2" {
  vpc_id            = aws_vpc.invideo_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = var.eks_public_2_az

  tags = {
    "Name"                                      = "eks_public_2"
    "Project"                                   = "invideo"
    "kubernetes.io/role/elb"                    = "1"      #required tag by EKS to identify public subnet for load balancer
    "kubernetes.io/cluster/${var.cluster_name}" = "shared" #required tag by EKS to identify public subnet for load balancer
  }
}


#creating two private subnets as per EKS requirements:
resource "aws_subnet" "eks_private_1" {
  vpc_id            = aws_vpc.invideo_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = var.eks_private_1_az

  tags = {
    "Name"    = "eks_private_1"
    "Project" = "invideo"
  }
}

resource "aws_subnet" "eks_private_2" {
  vpc_id            = aws_vpc.invideo_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = var.eks_private_2_az

  tags = {
    "Name"    = "eks_private_2"
    "Project" = "invideo"
  }
}