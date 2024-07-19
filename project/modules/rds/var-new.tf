variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "security_group_name" {
  description = "The name of the security group"
}

variable "security_group_description" {
  description = "The description of the security group"
  default = "Security group for RDS"
}

variable "ingress_from_port" {
  description = "The ingress from port"
  default = 3306
}

variable "ingress_to_port" {
  description = "The ingress to port"
  default = 3306
}

variable "ingress_protocol" {
  description = "The ingress protocol"
  default = "tcp"
}

variable "ingress_cidr_blocks" {
  description = "The ingress CIDR blocks"
  type        = list(string)
}

variable "egress_from_port" {
  description = "The egress from port"
  default = 0
}

variable "egress_to_port" {
  description = "The egress to port"
  default = 0
}

variable "egress_protocol" {
  description = "The egress protocol"
  default = "-1"
}

variable "egress_cidr_blocks" {
  description = "The egress CIDR blocks"
  type        = list(string)
  default = ["0.0.0.0/0"]
}

variable "db_subnet_group_name" {
  description = "The name of the DB subnet group"
}

variable "db_parameter_group_name" {
  description = "The name of the DB parameter group"
}

variable "db_family" {
  description = "The DB parameter group family"
  default = "mysql8.0"
}

variable "rds_module_version" {
  description = "The version of the RDS module to use"
  default = "5.2.0"
}

variable "db_identifier" {
  description = "The identifier of the RDS instance"
}

variable "db_engine" {
  description = "The database engine to use"
  default = "mysql"
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

variable "db_allocated_storage" {
  description = "The allocated storage in gigabytes"
  default = 20
}

variable "max_allocated_storage" {
  description = "The maximum allocated storage in gigabytes"
  default = 100
}

variable "db_name" {
  description = "The name of the database"
}

variable "db_username" {
  description = "The master username for the database"
}

variable "db_password" {
  description = "The master password for the database"
  sensitive = true
}

variable "db_port" {
  description = "The port on which the DB accepts connections"
  default = 3306
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  default = true

}

variable "maintenance_window" {
  description = "The window to perform maintenance in"
  default = "Mon:00:00-Mon:03:00"
}

variable "backup_window" {
  description = "The window to perform backups in"
  default = "03:00-06:00"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  default = false
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  default = true
}

variable "performance_insights_enabled" {
  description = "Specifies if Performance Insights are enabled"
  default = false
}

variable "performance_insights_retention_period" {
  description = "The amount of time in days to retain Performance Insights data"
  default = 7
}

variable "create_monitoring_role" {
  description = "Specifies if a monitoring role should be created"
  default = true
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when CloudWatch metrics are collected"
  default = 60
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to CloudWatch"
  type        = list(string)
  default = ["general"]
}

variable "create_cloudwatch_log_group" {
  description = "Specifies if a CloudWatch log group should be created"
  default = true
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default  = {}
}

variable "db_instance_tags" {
  description = "A map of tags to assign to the DB instance"
  type        = map(string)
  default  = {}
}

variable "db_option_group_tags" {
  description = "A map of tags to assign to the DB option group"
  type        = map(string)
  default  = {}
}

variable "db_parameter_group_tags" {
  description = "A map of tags to assign to the DB parameter group"
  type        = map(string)
  default  = {}
}

variable "db_subnet_group_tags" {
  description = "A map of tags to assign to the DB subnet group"
  type        = map(string)
  default  = {}
}
