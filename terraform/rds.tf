# terraform/rds.tf

variable "db_password" {
  description = "The password for the RDS database"
  type        = string
  sensitive   = true
}

resource "aws_security_group" "rds_sg" {
  name   = "rds-access-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_parameter_group" "default" {
  name   = "${var.cluster_name}-rds-params"
  family = "postgres15"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }
}

resource "aws_db_instance" "default" {
  identifier             = "app-db"
  engine                 = "postgres"
  engine_version         = "15.7"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_encrypted      = true
  db_name                = "appdb"
  username               = "dbadmin"
  password               = var.db_password 
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  parameter_group_name   = aws_db_parameter_group.default.name
  skip_final_snapshot    = true
  apply_immediately      = true
}

resource "aws_db_subnet_group" "default" {
  name       = "app-db-subnet-group"
  subnet_ids = module.vpc.private_subnets
}
