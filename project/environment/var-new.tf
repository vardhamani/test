# Standard variables
variable "application" { type = string }
variable "environment" { type = string }
variable "region" { type = string }
variable "service" { type = string }
variable "sub_environment" { type = string }

# remote_states variables
variable "workspace_state_bucket" {
  description = "The location of the object storage for remote states that are workspace-aware."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "security_group_name" {
  description = "The name of the security group
}


variable "ingress_cidr_blocks" {
  description = "The ingress CIDR blocks"
  type        = list(string)
}




variable "db_subnet_group_name" {
  description = "The name of the DB subnet group"
}

variable "db_parameter_group_name" {
  description = "The name of the DB parameter group"
}



variable "db_identifier" {
  description = "The identifier of the RDS instance"
}



variable "db_engine_version" {
  description = "The version of the database engine"
}

variable "db_major_engine_version" {
  description = "The major version of the database engine"
}

variable "db_instance_class" {
  description = "The instance class of the RDS instance"
}

variable "db_name" {
  description = "The name of the database"
}

variable "db_credentials_secret_name" {
  description = "The master username for the database"
}
