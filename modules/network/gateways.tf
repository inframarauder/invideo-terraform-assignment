#creating IGW for internet connectivity from VPC:
resource "aws_internet_gateway" "invideo_igw" {
  vpc_id = aws_vpc.invideo_vpc.id

  tags = {
    "Name"    = "invideo_igw"
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