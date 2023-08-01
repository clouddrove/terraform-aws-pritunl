#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "repository" {
  type        = string
  default     = "https://github.com/clouddrove/terraform-aws-pritunl"
  description = "Terraform current module repo"

  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^https://", var.repository))
    error_message = "The module-repo value must be a valid Git repo link."
  }
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = []
  description = "Label order, e.g. `name`,`application`."
}


variable "key_name" {
  type        = string
  default     = ""
  description = "The key name to use for the instance."
}

variable "ami" {
  type        = string
  default     = ""
  description = "The AMI to use for the instance."
}

variable "instance_type" {
  type        = string
  default     = ""
  description = "The type of instance to start. Updates to this field will trigger a stop/start of the EC2 instance."
}
variable "ebs_optimized" {
  type        = bool
  default     = false
  description = "If true, the launched EC2 instance will be EBS-optimized."
}


variable "monitoring" {
  type        = bool
  default     = true
  description = "If true, the launched EC2 instance will have detailed monitoring enabled. (Available since v0.6.0)."
}

variable "vpc_security_group_ids_list" {
  type        = list(string)
  default     = []
  description = "A list of security group IDs to associate with."
  sensitive   = true
}

variable "tenancy" {
  type        = string
  default     = "default"
  description = "The tenancy of the instance (if the instance is running in a VPC). An instance with a tenancy of dedicated runs on single-tenant hardware. The host tenancy is not supported for the import-instance command."
}

variable "instance_profile_enabled" {
  type        = bool
  default     = false
  description = "Flag to control the instance profile creation."
}

variable "root_block_device" {
  type        = list(any)
  default     = []
  description = "Customize details about the root block device of the instance. See Block Devices below for details."
}

variable "associate_public_ip_address" {
  type        = bool
  default     = true
  description = "Associate a public IP address with the instance."
  sensitive   = true
}

variable "assign_eip_address" {
  type        = bool
  default     = false
  description = "Assign an Elastic IP address to the instance."
  sensitive   = true
}

variable "user_data" {
  type        = string
  default     = ""
  description = "(Optional) A string of the desired User Data for the ec2."
}

variable "instance_tags" {
  type        = map(any)
  default     = {}
  description = "Instance tags."
}
variable "ebs_volume_size" {
  type        = number
  default     = 30
  description = "Size of the EBS volume in gigabytes."
}

variable "ebs_volume_type" {
  type        = string
  default     = "gp2"
  description = "The type of EBS volume. Can be standard, gp2 or io1."
}

variable "pritunl_enabled" {
  type        = bool
  default     = true
  description = "Flag to control the instance creation."
}

variable "ebs_volume_enabled" {
  type        = bool
  default     = false
  description = "Flag to control the ebs creation."
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "A list of VPC Subnet IDs to launch in."
  sensitive   = true
}

variable "iam_instance_profile" {
  type        = string
  default     = ""
  description = "The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile."
}
