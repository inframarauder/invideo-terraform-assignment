output "vpc_id" {
  value       = aws_vpc.invideo_vpc.id
  description = "Value of the VPC ID created"
}
output "db_subnet_id" {
  value = aws_subnet.invideo_db_subnet.id
  description = "DB private subnet id"
}