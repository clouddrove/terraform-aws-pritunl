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

variable "public_key" {
  type        = string
  default     = ""
  description = "The key name to use for the instance."
}

variable "instance_configuration" {
  description = "Configuration options for the EC2 instance including AMI, instance type, root block device, and user data."
  type = object({
    ami = optional(object({
      type         = string
      version      = optional(string)
      architecture = string
      region       = string
    }), null)
    ebs_optimized                        = optional(bool, false)
    instance_type                        = string
    monitoring                           = optional(bool, false)
    associate_public_ip_address          = optional(bool, true)
    disable_api_termination              = optional(bool, false)
    instance_initiated_shutdown_behavior = optional(string, "stop")
    placement_group                      = optional(string, "")
    tenancy                              = optional(string, "default")
    host_id                              = optional(string, null)
    user_data                            = optional(string, "")
    user_data_base64                     = optional(string, null)
    user_data_replace_on_change          = optional(bool, null)
    availability_zone                    = optional(string, null)
    get_password_data                    = optional(bool, null)
    private_ip                           = optional(string, null)
    secondary_private_ips                = optional(list(string), null)
    source_dest_check                    = optional(bool, true)
    ipv6_address_count                   = optional(number, null)
    ipv6_addresses                       = optional(list(string), null)
    hibernation                          = optional(bool, false)
    root_block_device                    = optional(list(any), [])
    ephemeral_block_device               = optional(list(any), [])
  })
  default = {
    instance_type = "t2.medium"
  }
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

variable "instance_count" {
  type        = number
  default     = 1
  description = "Number of instances to launch."
}

variable "iam_instance_profile" {
  type        = string
  default     = ""
  description = "The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile."
}

variable "instance_tags" {
  type        = map(any)
  default     = {}
  description = "Instance tags."
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "The ID of the VPC that the instance security group belongs to."
  sensitive   = true
}

variable "ssh_allowed_ip" {
  type        = list(any)
  default     = []
  description = "List of allowed ip."
}

variable "ssh_allowed_ports" {
  type        = list(any)
  default     = []
  description = "List of allowed ingress ports"
}
