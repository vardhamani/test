locals {
    # Determine name of security group and description. Use 'layer' IF set.
    sg_name        = var.layer == "" ? "${var.environment}.${var.sub_environment}.${var.service}.${var.function}" : "${var.environment}.${var.sub_environment}.${var.layer}.${var.service}.${var.function}"
    sg_description = var.layer == "" ? "Security group for the ${var.service} service's ${var.function} function in the ${var.environment}.${var.sub_environment} environment" : "Security group for the ${var.service} service's ${var.function} function in the ${var.layer} tier of the ${var.environment}.${var.sub_environment} environment"
  }

module "security-group" {
    source  = "terraform-aws-modules/security-group/aws"
    version = ">= 4.16.2, < 5.0.0"

    # Legacy: Use supplied name if non-empty. Otherwise name following policy.
    name   = var.name == "" ? local.sg_name : var.name
    vpc_id = var.vpc_id
# Legacy: Keep the description as it was before as a change recreates the SG. If
    # not set, then use 'null'. This puts in place a placeholder that will not change
    # (And not cause a rebuild for a description change). The std description is now added
    # to the tags for this reason.
    description = var.description == "" ? null : var.description

    # Populate tags with the non-legacy values. Tag changes will NOT recreate anything.
    tags = {
      # The UI attribute uses the 'Name' tag.
      Name = local.sg_name

      # Add some SG-specific MAS attributes for easier identification
      # Legacy: These may not make much sense until non-legacy variables set
      name        = local.sg_name
      description = local.sg_description
    }
  }