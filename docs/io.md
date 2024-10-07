## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami | The AMI to use for the instance. | `string` | `""` | no |
| ebs\_volume\_enabled | Flag to control the ebs creation. | `bool` | `false` | no |
| ebs\_volume\_size | Size of the EBS volume in gigabytes. | `number` | `30` | no |
| ebs\_volume\_type | The type of EBS volume. Can be standard, gp2 or io1. | `string` | `"gp2"` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| iam\_instance\_profile | The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile. | `string` | `""` | no |
| instance\_count | Number of instances to launch. | `number` | `1` | no |
| instance\_tags | Instance tags. | `map(any)` | `{}` | no |
| instance\_type | The type of instance to start. Updates to this field will trigger a stop/start of the EC2 instance. | `string` | n/a | yes |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| public\_key | The key name to use for the instance. | `string` | `""` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-pritunl"` | no |
| root\_block\_device | Customize details about the root block device of the instance. See Block Devices below for details. | `list(any)` | `[]` | no |
| ssh\_allowed\_ip | List of allowed ip. | `list(any)` | `[]` | no |
| ssh\_allowed\_ports | List of allowed ingress ports | `list(any)` | `[]` | no |
| subnet\_ids | A list of VPC Subnet IDs to launch in. | `list(string)` | `[]` | no |
| user\_data | (Optional) A string of the desired User Data for the ec2. | `string` | `""` | no |
| vpc\_id | The ID of the VPC that the instance security group belongs to. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance\_id | The instance ID. |
| private\_ip | Private IP of instance. |
| tags | The instance tags. |
