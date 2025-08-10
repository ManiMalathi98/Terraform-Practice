
# Use existing subnet group (or create one with existing subnet IDs)
resource "aws_db_subnet_group" "existing_subnet_group" {
  name       = "existing-db-subnet-group"
  subnet_ids = [
    "subnet-0991197a337fe2fa9", # Replace with your existing subnet IDs
    "subnet-041efeaa1bd1d4125"
  ]
  tags = {
    Name = "existing-db-subnet-group"
  }
}

# Security Group allowing MySQL access
resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = "vpc-0bc13a462ce428b71"      # Your existing VPC ID

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]           # Adjust for security!
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# Main RDS instance
resource "aws_db_instance" "rds" {
  identifier              = "database-1"
  engine                  = "mysql"
  engine_version          = "8.0.42"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "Mani"
  username                = "admin"
  password                = "Malathik"
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.existing_subnet_group.name
  publicly_accessible     = true
  port                    = 3306
  skip_final_snapshot     = true
  deletion_protection     = false
  multi_az                = false
  backup_retention_period = 7

  tags = {
    Name = "Mani-database"
  }
}

# Read Replica instance
resource "aws_db_instance" "read_replica" {
  identifier             = "replica-database-1"
  replicate_source_db    = aws_db_instance.rds.arn
  instance_class         = "db.t3.micro"
  publicly_accessible    = true
  db_subnet_group_name   = aws_db_subnet_group.existing_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  deletion_protection    = false

  tags = {
    Name = "Mani Read Replica"
  }
}
