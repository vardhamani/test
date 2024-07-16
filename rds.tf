# Fetch existing VPC
data "aws_vpc" "selected" {
  id = var.vpc_id
}

# Fetch subnets in the existing VPC
data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

# Create a new security group for RDS
resource "aws_security_group" "rds" {
  name        = var.security_group_name
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with more restrictive CIDR block if needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# Create a new DB subnet group
resource "aws_db_subnet_group" "default" {
  name       = var.db_subnet_group_name
  subnet_ids = data.aws_subnets.selected.ids

  tags = var.tags
}

# Create a new DB parameter group
resource "aws_db_parameter_group" "default" {
  name   = var.db_parameter_group_name
  family = "mysql8.0"

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  tags = var.tags
}

# Create RDS instance using the module
module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.2.0"

  identifier             = var.db_identifier
  engine                 = "mysql"
  engine_version         = "8.0"
  family                 = "mysql8.0"
  major_engine_version   = "8.0"
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  max_allocated_storage  = var.max_allocated_storage
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  port                   = var.db_port
  multi_az               = var.multi_az
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.default.name
  maintenance_window     = var.maintenance_window
  backup_window          = var.backup_window
  skip_final_snapshot    = var.skip_final_snapshot
  deletion_protection    = var.deletion_protection
  performance_insights_enabled          = false
  # performance_insights_retention_period = var.performance_insights_retention_period
  create_monitoring_role                = var.create_monitoring_role
  monitoring_interval                   = var.monitoring_interval
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
  create_cloudwatch_log_group           = var.create_cloudwatch_log_group
  tags                                  = var.tags
  db_instance_tags                      = var.db_instance_tags
  db_option_group_tags                  = var.db_option_group_tags
  db_parameter_group_tags               = var.db_parameter_group_tags
  db_subnet_group_tags                  = var.db_subnet_group_tags
}
