data "aws_secretsmanager_secret" "db_credentials" {
  name = var.db_credentials_secret_name
}

data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = data.aws_secretsmanager_secret.db_credentials.id
}

locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)
}

module "database" {
  source = "../modules/database"
  vpc_id                        = var.vpc_id
  security_group_name           = var.security_group_name
  ingress_cidr_blocks           = var.ingress_cidr_blocks
  db_subnet_group_name          = var.db_subnet_group_name
  db_parameter_group_name       = var.parameter_group_name
  db_identifier                 = var.db_identifier
  db_engine_version             = var.db_engine_version
  db_major_engine_version       = var.db_major_engine_version
  db_instance_class             = var.db_instance_class
  
  db_name                       = var.db_name
  db_username                   = local.db_username
  db_password                   = local.db_password
  tags                          = var.tags
}
