#creating the VPC:
resource "aws_vpc" "invideo_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name"    = "invideo_vpc"
    "Project" = "invideo"
  }
}