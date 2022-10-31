##################################################
# AWS Common Variable(s)
##################################################
variable "name" {
  description = "The ec2 resource"
  type        = string
  default     = "poc"
}

variable "region" {
  description = "The EC2 region"
  type        = string
  default     = "us-east-1"
}

##################################################
# AWS VPC Variable(s)
##################################################
variable "cidr" {
  description = "The VIPC CIDR block"
  type        = string
  default     = "10.1.0.0/16"
}

variable "azs" {
  description = "The AVailibility Zone"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "enable_nat_gateway" {
  description = "Whether or not to enable nat gateway"
  type        = bool
  default     = true
}

variable "private_subnets" {
  description = "Private subnets"
  type        = list(string)
  default     = ["10.1.2.0/24", "10.1.3.0/24"]
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
  default     = ["10.1.0.0/24", "10.1.1.0/24"]
}

##################################################
# AWS EC2 Variable(s)
##################################################
variable "ami" {
  description = "The EC2 AMI_ID"
  type        = string
  default     = "ami-06640050dc3f556bb"
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "root_volume_size" {
  description = "The EC2 root volume size"
  type        = string
  default     = "20"
}

variable "root_volume_type" {
  description = "The root EBS volume type"
  type        = string
  default     = "gp2"
}

##################################################
# AWS Auto-Scaling Group Variable(s)
##################################################
variable "min_size" {
  description = "The minimum size of EC2 in ASG"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum size of EC2 in ASG"
  type        = number
  default     = 6
}

variable "desired_capacity" {
  description = "The desired number of EC2 in ASG"
  type        = number
  default     = 2
}

variable "wait_for_capacity_timeout" {
  description = "The wait for capacity timeout"
  type        = number
  default     = 0
}

variable "health_check_type" {
  description = "Controls how health checking is done"
  type        = string
  default     = "EC2"
}

##################################################
# AWS Launch Template Variable(s)
##################################################
variable "create_launch_template" {
  description = "Wheather or not to create launch template"
  type        = bool
  default     = true
}

variable "launch_template_description" {
  description = "The Launch template discription"
  type        = string
  default     = "Launch template for EC2"
}

variable "update_default_version" {
  description = "Where or not to update the default version of the launch template"
  type        = bool
  default     = true
}

variable "device_name" {
  description = "The device name for EC2 root file system in launch template"
  type        = string
  default     = "/dev/sda1"
}

variable "no_device" {
  description = "The ec2 device number"
  type        = number
  default     = 0
}

variable "delete_on_termination" {
  description = "Whether or not to delete the root EBS volume on EC2 termination"
  type        = bool
  default     = true
}

variable "encrypted" {
  description = "Whether or not to encrypt the EBS volume"
  type        = bool
  default     = true
}

variable "description" {
  description = "The network interface name"
  type        = string
  default     = "eth0"
}

variable "device_index" {
  description = "The network interface index as an attachment"
  type        = number
  default     = 0
}

##################################################
# AWS Load Balancer Variable(s)
##################################################
variable "load_balancer_type" {
  description = "The load balancer type"
  type        = string
  default     = "network"
}

# Target Group variables
variable "backend_protocol" {
  description = "The backend protocol for target group"
  type        = string
  default     = "TCP"
}

variable "backend_port" {
  description = "The backend port for target group"
  type        = number
  default     = 80
}

variable "target_type" {
  description = "The backend target group type"
  type        = string
  default     = "ip"
}

# Load Balancer Listerner variables
variable "listener_port" {
  description = "The load balancer listener port"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "The load balancer listener protocol"
  type        = string
  default     = "TCP"
}

variable "target_group_index" {
  description = "The load balancer target group index"
  type        = number
  default     = 0
}

##################################################
# AWS S3 Bucket Variable(s)
##################################################
variable "s3_access_control_list" {
  description = "The S3 bucket access control list"
  type        = string
  default     = "private"
}

variable "s3_objects_list" {
  description = "The list of S3 object to create"
  type        = list(string)
  default     = ["Images", "Logs"]
}

# S3 bucket life cycle variables
variable "image_id" {
  description = "The S3 life cycle rule got Images object"
  type        = string
  default     = "ImagesToGlacierAfter90Days"
}

variable "rule_status" {
  description = "The S3 life cycle rule status"
  type        = string
  default     = "Enabled"
}

variable "number_of_days" {
  description = "The number of days to rules get executed"
  type        = number
  default     = 90
}

variable "s3_storage_class" {
  description = "The s3 stroage class for Glacier rule"
  type        = string
  default     = "GLACIER"
}

variable "log_id" {
  description = "The S3 life cycle rule got Logs object"
  type        = string
  default     = "LogsToDeleteAfter90Days"
}

##################################################
# AWS Default Tags Variable(s)
##################################################
variable "default_tags" {
  description = "Default tags"
  type        = map(any)
  default = {
    Name        = "poc"
    Terraform   = "true"
    Environment = "dev"
  }
}
