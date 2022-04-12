#creating the VPC:
resource "aws_vpc" "invideo_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name"    = "invideo_vpc"
    "Project" = "invideo"
  }
}

#creating IGW for internet connectivity from VPC:
resource "aws_internet_gateway" "invideo_igw" {
  vpc_id = aws_vpc.invideo_vpc.id

  tags = {
    "Name"    = "invideo_igw"
    "Project" = "invideo"
  }
}


#creating two private subnets for DB:
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

#creating NAT gateway to allow internet access from private subnets:
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    "Name"    = "nat_eip"
    "Project" = "invideo"
  }
}

resource "aws_nat_gateway" "invideo_ngw" {
  subnet_id     = aws_subnet.eks_public_1.id
  allocation_id = aws_eip.nat_eip.id

  tags = {
    "Name"    = "invideo_ngw"
    "Project" = "invideo"
  }

  depends_on = [
    aws_internet_gateway.invideo_igw
  ]
}

#creating route table for private subnets:
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.invideo_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.invideo_ngw.id
  }

  tags = {
    "Name"    = "private_rt"
    "Project" = "invideo"
  }

  depends_on = [
    aws_nat_gateway.invideo_ngw
  ]
}

#creating route table for public subnets:
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.invideo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.invideo_igw.id
  }

  tags = {
    "Name"    = "public_rt"
    "Project" = "invideo"
  }

  depends_on = [
    aws_internet_gateway.invideo_igw
  ]
}

#creating route table associations for private subnets:
resource "aws_route_table_association" "private_rta_1" {
  subnet_id      = aws_subnet.eks_private_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rta_2" {
  subnet_id      = aws_subnet.eks_private_2.id
  route_table_id = aws_route_table.private_rt.id
}

#creating route table associations for public subnets:
resource "aws_route_table_association" "public_rta_1" {
  subnet_id      = aws_subnet.eks_public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rta_2" {
  subnet_id      = aws_subnet.eks_public_2.id
  route_table_id = aws_route_table.public_rt.id
}