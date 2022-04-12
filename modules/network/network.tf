#creating the VPC:
resource "aws_vpc" "invideo_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name"    = "invideo_vpc"
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

