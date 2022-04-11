#creating the VPC:
resource "aws_vpc" "invideo_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name"    = "invideo_vpc"
    "Project" = "invideo"
  }
}

#creating the private subnet for DB:
resource "aws_subnet" "invideo_db_subnet" {
  vpc_id     = aws_vpc.invideo_vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    "Name"    = "private_db"
    "Project" = "invideo"
  }
}

#creating the private subnet for webservers:
resource "aws_subnet" "invideo_webserver_subnet" {
  vpc_id     = aws_vpc.invideo_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    "Name"    = "private_webserver"
    "Project" = "invideo"
  }
}

#creating the public subnet for loadbalancer:
resource "aws_subnet" "invideo_loadbalancer_subnet" {
  vpc_id     = aws_vpc.invideo_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    "Name"    = "public"
    "Project" = "invideo"
  }
}


#creating internet gateway for public subnet:
resource "aws_internet_gateway" "invideo_igw" {
  vpc_id = aws_vpc.invideo_vpc.id

  tags = {
    "Name"    = "invideo_igw"
    "Project" = "invideo"
  }
}

#creating eip for NAT Gateway:
resource "aws_eip" "invideo_nat_eip" {
  vpc = true

  tags = {
    "Name"    = "invideo_nat_eip"
    "Project" = "invideo"
  }

  depends_on = [
    aws_internet_gateway.invideo_igw
  ]
}

#creating NAT gateway for private webserver subnet to access the internet:
resource "aws_nat_gateway" "invideo_nat_gateway" {
  subnet_id     = aws_subnet.invideo_webserver_subnet.id
  allocation_id = aws_eip.invideo_nat_eip.id

  tags = {
    "Name"    = "invideo_ngw"
    "Project" = "invideo"
  }

  depends_on = [
    aws_eip.invideo_nat_eip,
  ]
}

#adding the IGW to the route table for the public subnet:
resource "aws_route_table" "invideo_public_rt" {
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

#route table associations for public subnet:
resource "aws_route_table_association" "invideo_public_rt_assoc" {
  subnet_id      = aws_subnet.invideo_loadbalancer_subnet.id
  route_table_id = aws_route_table.invideo_public_rt.id
}

#adding NGW to the route table for private webserver subnet:
resource "aws_route_table" "invideo_private_rt" {
  vpc_id = aws_vpc.invideo_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.invideo_nat_gateway.id
  }

  tags = {
    "Name"    = "private_rt"
    "Project" = "invideo"
  }

  depends_on = [
    aws_nat_gateway.invideo_nat_gateway
  ]
}

#route table associations for private webserver subnet:
resource "aws_route_table_association" "invideo_private_rt_assoc" {
  subnet_id      = aws_subnet.invideo_webserver_subnet.id
  route_table_id = aws_route_table.invideo_private_rt.id
}

