output "vpc_id" {
  value       = aws_vpc.invideo_vpc.id
  description = "Value of the VPC ID created"
}
output "db_subnet_ids" {
  value       = [aws_subnet.invideo_db_subnet_1.id, aws_subnet.invideo_db_subnet_2.id]
  description = "DB private subnet ids"
}