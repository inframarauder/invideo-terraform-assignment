#create subnet group for DB:
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name    = "db_subnet_group"
    Project = "invideo"
  }
}

#create security group for RDS:
resource "aws_security_group" "rds_sg" {
  name   = "rds_sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "rds_sg"
    Project = "invideo"
  }
}


#create RDS postgreSQL instance:
resource "aws_db_instance" "postgresdb" {
  identifier             = "postgresdb"
  instance_class         = "db.t3.micro"
  multi_az               = true
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = 13
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true

  tags = {
    "Name"    = "postgresdb"
    "Project" = "invideo"
  }
}

