

module "ec2" {
  source      = "clouddrove/ec2/aws"
  version     = "0.15.1"
  name        = var.name
  environment = var.environment
  label_order = var.label_order

  #instance
  instance_enabled = var.pritunl_enabled
  instance_count   = 1
  ami              = var.ami
  instance_type    = var.instance_type
  monitoring       = var.monitoring
  tenancy          = "default"

  #Networking
  vpc_security_group_ids_list = var.vpc_security_group_ids_list
  subnet_ids                  =  var.subnet_ids
  assign_eip_address          = true
  associate_public_ip_address = true

  #Keypair
  key_name = var.key_name

  #IAM
  instance_profile_enabled = true
  iam_instance_profile     = var.iam_instance_profile

  #Root Volume
  root_block_device = var.root_block_device

  #EBS Volume
  ebs_optimized      = var.ebs_optimized
  ebs_volume_enabled = var.ebs_volume_enabled
  ebs_volume_type    = var.ebs_volume_type
  ebs_volume_size    = var.ebs_volume_size

  #DNS
  dns_enabled = false

  #Tags
  instance_tags = var.instance_tags

  # Metadata
  metadata_http_tokens_required        = "optional"
  metadata_http_endpoint_enabled       = "enabled"
  metadata_http_put_response_hop_limit = 2
  #user data
  user_data = var.user_data
}
