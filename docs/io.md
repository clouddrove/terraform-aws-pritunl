## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ebs\_volume\_enabled | Flag to control the ebs creation. | `bool` | `false` | no |
| ebs\_volume\_size | Size of the EBS volume in gigabytes. | `number` | `30` | no |
| ebs\_volume\_type | The type of EBS volume. Can be standard, gp2 or io1. | `string` | `"gp2"` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| iam\_instance\_profile | The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile. | `string` | `""` | no |
| instance\_configuration | Configuration options for the EC2 instance including AMI, instance type, root block device, and user data. | <pre>object({<br>    ami = optional(object({<br>      type         = string<br>      version      = optional(string)<br>      architecture = string<br>      region       = string<br>    }), null)<br>    ebs_optimized                        = optional(bool, false)<br>    instance_type                        = string<br>    monitoring                           = optional(bool, false)<br>    associate_public_ip_address          = optional(bool, true)<br>    disable_api_termination              = optional(bool, false)<br>    instance_initiated_shutdown_behavior = optional(string, "stop")<br>    placement_group                      = optional(string, "")<br>    tenancy                              = optional(string, "default")<br>    host_id                              = optional(string, null)<br>    user_data                            = optional(string, "")<br>    user_data_base64                     = optional(string, null)<br>    user_data_replace_on_change          = optional(bool, null)<br>    availability_zone                    = optional(string, null)<br>    get_password_data                    = optional(bool, null)<br>    private_ip                           = optional(string, null)<br>    secondary_private_ips                = optional(list(string), null)<br>    source_dest_check                    = optional(bool, true)<br>    ipv6_address_count                   = optional(number, null)<br>    ipv6_addresses                       = optional(list(string), null)<br>    hibernation                          = optional(bool, false)<br>    root_block_device                    = optional(list(any), [])<br>    ephemeral_block_device               = optional(list(any), [])<br>  })</pre> | <pre>{<br>  "instance_type": "t2.medium"<br>}</pre> | no |
| instance\_count | Number of instances to launch. | `number` | `1` | no |
| instance\_tags | Instance tags. | `map(any)` | `{}` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| public\_key | The key name to use for the instance. | `string` | `""` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-pritunl"` | no |
| ssh\_allowed\_ip | List of allowed ip. | `list(any)` | `[]` | no |
| ssh\_allowed\_ports | List of allowed ingress ports | `list(any)` | `[]` | no |
| subnet\_ids | A list of VPC Subnet IDs to launch in. | `list(string)` | `[]` | no |
| vpc\_id | The ID of the VPC that the instance security group belongs to. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance\_id | The instance ID. |
| private\_ip | Private IP of instance. |
| tags | The instance tags. |

