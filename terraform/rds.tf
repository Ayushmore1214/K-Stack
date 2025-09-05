resource "random_password" "db_password" {
  length  = 16
  special = true
}

resource "aws_security_group" "rds_sg" {
  name   = "rds-access-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "default" {
  identifier           = "app-db"
  engine               = "postgres"
  engine_version       = "15.3"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  storage_encrypted    = true
  db_name              = "appdb"
  username             = "dbadmin"
  password             = random_password.db_password.result
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "default" {
  name       = "app-db-subnet-group"
  subnet_ids = module.vpc.private_subnets
}