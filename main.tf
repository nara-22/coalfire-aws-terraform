##################################################
# AWS VPC Resource(s)
##################################################
module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  name               = "${var.name}-vpc"
  cidr               = var.cidr
  azs                = var.azs
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  enable_nat_gateway = var.enable_nat_gateway

  tags = {
    Name        = "${var.default_tags.Name}-vpc"
    Terraform   = var.default_tags.Terraform
    Environment = var.default_tags.Environment
  }
}

##################################################
# AWS Security Group Resource(s)
##################################################
module "sg_22" {
  source              = "terraform-aws-modules/security-group/aws//modules/ssh"
  name                = "${var.default_tags.Name}-sg-22"
  description         = "Allows ssh connection"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = [var.cidr]
}

module "sg_80" {
  source              = "terraform-aws-modules/security-group/aws//modules/http-80"
  name                = "${var.default_tags.Name}-sg-80"
  description         = "Security group for web-server with HTTP port open within VPC"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = [var.cidr]
}

##################################################
# AWS EC2 Key Pair(s)
##################################################
module "key_pair" {
  source     = "terraform-aws-modules/key-pair/aws"
  key_name   = "nara"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUNqN1BlbTx8b55UlJ504/BtdLZZoYjnEpRjuLnhsyQIcviEZ0p7kuQIyBZlVgBb+/5Mf4qTXnFsBIL99O95Z0lu0Sf1j/uAXzxoe30m6neCCwsrqfZRxfZr1+t+QepxePvLNA0r64EiPPZ/3yuLfbxMJddWm3hzhPwb3mUcv/rXdVVy+9SKvGTJRr6SFSNLmv6Ufcpd+g9I9DUpa4csa0Xnbapw7L7ftUEu7IF3ED9KMY83OW/ntJR7prK5krvVwulIYVlsw1JXaHETe8F9fv57REUeS/bhkuyWLtvFXo463qIlVu444MdWw87UnwOhftbw1YuYgIe8W2HrkKJYXmwT9l22+c48K79uJEzzFzcK9XxfU3GOb4d4XRwwUlJtu7CRm3ujNZa7Ejtyi115vW5XoP6WiwPjPCGSy5zLsGBx7eRy+5Br9EgwBN3IU98yFCZAZYfoA7rinGiOMDVN+icRT+HfufXINJmzcRgmeF+dIq+r0jK0yEP7hZY05Oc6s= dinaraaidarova"
}

##################################################
# AWS EC2 Resource(s)
##################################################
module "ec2" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${var.name}-ec2"
  ami                    = var.ami
  key_name               = module.key_pair.key_pair_name
  instance_type          = var.instance_type
  vpc_security_group_ids = [module.sg_22.security_group_id]
  subnet_id              = module.vpc.public_subnets[1]

  # Adding EBS with custome size
  root_block_device = [
    {
      volume_size = var.root_volume_size
    }
  ]

  tags = {
    Name        = "${var.default_tags.Name}-ec2"
    Terraform   = var.default_tags.Terraform
    Environment = var.default_tags.Environment
  }
}

##################################################
# AWS Auto-Scaling Group Resource(s)
##################################################
module "asg" {
  source                    = "terraform-aws-modules/autoscaling/aws"
  name                      = "${var.default_tags.Name}-asg"
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  health_check_type         = var.health_check_type
  vpc_zone_identifier       = module.vpc.private_subnets

  # Launch template
  create_launch_template      = var.create_launch_template
  launch_template_name        = "${var.default_tags.Name}-asg"
  launch_template_description = var.launch_template_description
  update_default_version      = var.update_default_version
  image_id                    = var.ami
  instance_type               = var.instance_type

  block_device_mappings = [
    {
      # Root volume with custom size
      device_name = var.device_name
      no_device   = var.no_device
      ebs = {
        delete_on_termination = var.delete_on_termination
        encrypted             = var.encrypted
        volume_size           = var.root_volume_size
        volume_type           = var.root_volume_type
      }
    }
  ]

  network_interfaces = [
    {
      delete_on_termination = var.delete_on_termination
      description           = var.description
      device_index          = var.device_index
      security_groups       = [module.sg_80.security_group_id] // Attaching above created SG
    }
  ]

  user_data = filebase64("${path.module}/install.sh")

  tags = {
    Name        = "${var.default_tags.Name}-asg-ec2"
    Terraform   = var.default_tags.Terraform
    Environment = var.default_tags.Environment
  }
}

##################################################
# AWS LoadBalancer Resource(s)
##################################################
module "lb" {
  source             = "terraform-aws-modules/alb/aws"
  name               = "${var.default_tags.Name}-lb"
  load_balancer_type = var.load_balancer_type
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.private_subnets

  target_groups = [
    {
      name_prefix      = "${var.default_tags.Name}-"
      backend_protocol = var.backend_protocol
      backend_port     = var.backend_port
      target_type      = var.target_type
    }
  ]

  http_tcp_listeners = [
    {
      port               = var.listener_port
      protocol           = var.listener_protocol
      target_group_index = var.target_group_index
    }
  ]

  tags = {
    Name        = "${var.default_tags.Name}-tgr"
    Terraform   = var.default_tags.Terraform
    Environment = var.default_tags.Environment
  }
}

##################################################
# AWS S3 Bucket Resource(s)
##################################################
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = "${var.default_tags.Name}-nara-s3-bucket"
  acl    = var.s3_access_control_list
}

module "s3_objects" {
  for_each = toset(var.s3_objects_list)
  source   = "terraform-aws-modules/s3-bucket/aws//modules/object"
  bucket   = module.s3_bucket.s3_bucket_id
  key      = each.key

  tags = {
    Name        = "${var.default_tags.Name}-s3"
    Terraform   = var.default_tags.Terraform
    Environment = var.default_tags.Environment
  }
}

# Creates rules for Image and Log objects
resource "aws_s3_bucket_lifecycle_configuration" "s3_life_cycle_rules" {
  bucket = module.s3_bucket.s3_bucket_id
  rule {
    id     = var.image_id
    status = var.rule_status
    transition {
      days          = var.number_of_days
      storage_class = var.s3_storage_class
    }
  }

  rule {
    id     = var.log_id
    status = var.rule_status
    expiration {
      days = var.number_of_days
    }
  }
}
