variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}


variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  type        = string
}

variable "db_parameter_group_name" {
  description = "Name of the DB parameter group"
  type        = string
}

variable "security_group_name" {
  description = "Name of the security group for RDS"
  default     = "rds-sg"
  type        = string
}

variable "db_identifier" {
  description = "Identifier for the RDS instance"
  default     = "my-rds-instance"
}

variable "db_name" {
  description = "Database name"
  default     = "mydatabase"
}

variable "db_username" {
  description = "Database username"
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  default     = "yourpassword"
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "RDS allocated storage in GB"
  default     = 20
}

variable "max_allocated_storage" {
  description = "RDS maximum allocated storage in GB"
  default     = 100
}

variable "db_port" {
  description = "Database port"
  default     = 3306
}

variable "multi_az" {
  description = "Enable multi-AZ RDS instance"
  default     = true
}

variable "maintenance_window" {
  description = "Maintenance window for the RDS instance"
  default     = "Mon:00:00-Mon:03:00"
}

variable "backup_window" {
  description = "Backup window for the RDS instance"
  default     = "03:00-06:00"
}

variable "skip_final_snapshot" {
  description = "Whether to skip taking a final snapshot before deleting the DB instance"
  default     = true
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection on the RDS instance"
  default     = false
}

variable "create_monitoring_role" {
  description = "Create IAM role for enhanced monitoring"
  default     = true
}

variable "monitoring_interval" {
  description = "Monitoring interval in seconds"
  default     = 60
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to CloudWatch"
  type        = list(string)
  default     = ["general"]
}

variable "create_cloudwatch_log_group" {
  description = "Create CloudWatch log group"
  default     = true
}

variable "parameters" {
  description = "List of DB parameters"
  type        = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {
    Name        = "my-rds-instance"
    Environment = "dev"
  }
}

variable "db_instance_tags" {
  description = "Tags to apply to the RDS instance"
  type        = map(string)
  default     = {
    Sensitive = "high"
  }
}

variable "db_option_group_tags" {
  description = "Tags to apply to the RDS option group"
  type        = map(string)
  default     = {
    Sensitive = "low"
  }
}

variable "db_parameter_group_tags" {
  description = "Tags to apply to the RDS parameter group"
  type        = map(string)
  default     = {
    Sensitive = "low"
  }
}

variable "db_subnet_group_tags" {
  description = "Tags to apply to the RDS subnet group"
  type        = map(string)
  default     = {
    Sensitive = "high"
  }
}
