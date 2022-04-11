#creating the VPC:
resource "aws_vpc" "invideo_vpc" {
  cidr_block = "10.0.0.0/16" 

  tags = {
    "Name" = "invideo_vpc"
  }
}

#creating the private subnet for DB:
resource "aws_subnet" "invideo_db_subnet" {
  vpc_id = aws_vpc.invideo_vpc.id
  cidr_block = "10.0.0.0/24" 

  tags = {
    "Name" = "invideo_db_subnet"
  }
}

#creating the private subnet for webservers:
resource "aws_subnet" "invideo_webserver_subnet" {
  vpc_id = aws_vpc.invideo_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    "Name" = "invideo_webserver_subnet"
  }
}

#creating the public subnet for loadbalancer:
resource "aws_subnet" "invideo_loadbalancer_subnet" {
  vpc_id = aws_vpc.invideo_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    "Name" = "invideo_loadbalancer_subnet"
  }
}
