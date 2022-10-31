# terraform-aws-nara

Built a VPC and configured subnets automatically by using ready public VPC module (url shared below under the list of websites), 2 public subnets and 2 private subnets in 2 AZs: us-east-1 and us-east-2. VPC module creates and configures Internet Gateway and Nat Gateways. Created one EC2 instance running Red Hat Linux in public subnet in us-east-2 AZ with 20 GB storage. Created 1 auto scaling group that will spread out instances across 2 private subnets.
- Using Red Hat Linux
- 20 GB storage
- Script the installation of Apache web server(httpd) on these instances

#!/bin/bash 
yum install httpd
systemctl start httpd
systemctl enable httpd
systemctl status httpd

- 2 minimum, 6 maximum hosts
Created 1 application load balancer that listens on TCP port 80 (HTTP) and forwards traffic to the
ASG in 2 private subnets.

And created S3 bucket with two folders and the following lifecycle policies:
- "Images" folder - move objects older than 90 days to glacier
- "Logs" folder - delete objects older than 90 days

## Architectural Diagram:
![Alt text here](/img/nara.jpg)

## Logged session screenshot:
![Alt text here](/img/logged_session.jpg)

## The list of website I have use:
### **VPC resources:**
- [VPC Terraform Module](https://github.com/terraform-aws-modules/terraform-aws-vpc)

### **EC2 module:**
- [EC2 Terraform Module](https://github.com/terraform-aws-modules/terraform-aws-ec2-instance)
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

### **Key-Pair module:**
- [Key-Pair Terraform Module](https://github.com/terraform-aws-modules/terraform-aws-key-pair)
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair

### **Auto-Scaling Group:**
- [Auto-Scalling Terraform Module](https://github.com/terraform-aws-modules/terraform-aws-autoscaling)
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#argument-reference


### **Launch Configuration:**
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration

### **S3 bucket, object, and life cycle:**
- [S3 Bucket Terraform Module](https://github.com/terraform-aws-modules/terraform-aws-s3-bucket)
- [S3 Bucket Object Terraform Module](https://github.com/terraform-aws-modules/terraform-aws-s3-bucket/tree/master/modules/object)
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#argument-reference
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object

### **Security Group module:**
- [Security Group Terraform Module](https://github.com/terraform-aws-modules/terraform-aws-security-group)
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule

### **Load Balancer module:**
- [ALB Terraform Module](https://github.com/terraform-aws-modules/terraform-aws-alb)
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group

