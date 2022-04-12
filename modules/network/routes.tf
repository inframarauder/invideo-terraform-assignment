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