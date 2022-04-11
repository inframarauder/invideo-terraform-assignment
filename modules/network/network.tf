#creating the VPC:
resource "aws_vpc" "invideo_vpc" {
  cidr_block = "10.0.0.0/16" #-->65536 - 5 = 65531 IP addresses

  tags = {
    "Name" = "invideo_vpc"
  }
}