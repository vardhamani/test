# Standard variables
variable "region" {
   type = string
   default = "us-east-1"
}

# # remote_states variables
# variable "workspace_state_bucket" {
#   description = "The location of the object storage for remote states that are workspace-aware."
#   type        = string
# }
variable "name" {
  default = "my-secret" 
  
}
variable "db_username" {
  description = "The database username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The database password"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "subnet_ids" {
  description = "list of subnet ids"
  type = list(string) 
}

# variable "security_group_description" {
#    description = "The name of the security group"
#    default = ""
#  }

#  variable "security_group_name" {
#    description = "The name of the security group"
#  }


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

# variable "db_credentials_secret_name" {
#   description = "The master username for the database"
# }

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default  = {}
}

variable "db_credentials_secret_name" {
  description = "A map of tags to assign to the DB parameter group"
  type        = string
  default  = "db_secret1"
}

# # Add these variables
# variable "db_username" {
#   description = "The master username for the database"
#   type        = string
# }

# variable "db_password" {
#   description = "The master password for the database"
#   type        = string
#   sensitive   = true
# }


variable "environment" {
  type    = string
  default = "development"
}

variable "sub_environment" {
  type    = string
  default = "test"
}

variable "service" {
  type    = string
  default = "jira"
}

variable "layer" {
  description = "(Optional) Set if the security group is aligned with a layer (tier)."
  type        = string
  default     = "rds"
}

variable "function" {
  description = "A short functional name for this security group."
  type        = string
  default     = "rds"
}


variable "create_db_subnet_group" {
  description = "Specifies whether to create a new DB subnet group"
  type        = bool
  default     = true
}


variable "db_subnet_group_use_name_prefix" {
  type = bool
  default = true
}


variable "parameter_group_use_name_prefix" {
  type = bool
  default = true
}

variable "create_db_parameter_group" {
  description = "Specifies whether to create a new DB parameter group"
  type        = bool
  default     = true
}

variable "create_db_option_group" {
  description = "Specifies whether to create a new DB option group"
  type        = bool
  default     = true
}

variable "option_group_name" {
  description = "The name of the DB option group"
  type        = string
  default     = ""
}

variable "option_group_use_name_prefix" {
  description = "Whether to use a name prefix for the DB option group"
  type        = bool
  default     = true
}
