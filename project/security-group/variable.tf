variable "environment" {
  type    = string
}

variable "sub_environment" {
  type    = string
}

variable "service" {
  type    = string
}

variable "layer" {
  description = "(Optional) Set if the security group is aligned with a layer (tier)."
  type        = string
  default = ""
}

variable "function" {
  description = "A short functional name for this security group."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group."
  type        = string
  
  validation {
    condition     = can(regex("^vpc-[[:xdigit:]]{17}$", var.vpc_id))
    error_message = "The VPC ID must be valid for AWS."
  }
}

variable "name" {
  description = "Name of security group."
  type        = string
  default     = ""
  
  validation {
    condition = anytrue([
      var.name == "",
      can(regex("CMS\\w{3}.", var.name))
    ])
    error_message = "The security group name must be empty OR match the naming policy requirements."
  }
}

variable "description" {
  type    = string
  default = ""
}

# Supports older IAC. This is now IGNORED.
variable "tags" {
  type    = map(string)
  default = {}
}

