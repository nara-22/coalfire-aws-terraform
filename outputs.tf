##################################################
# AWS VPC Output(s)
##################################################
output "poc_vpc_id" {
  value = module.vpc.vpc_id
}

output "poc_vpc_arn" {
  value = module.vpc.vpc_arn
}

##################################################
# AWS Security Group Output(s)
##################################################
output "poc_sg_22" {
  value = module.sg_22.security_group_id
}

output "poc_sg_80" {
  value = module.sg_80.security_group_id
}