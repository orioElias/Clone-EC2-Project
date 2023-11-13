data "aws_instances" "ireland_instances" {
  provider = aws.ireland
  filter {
    name   = "instance-id"
    values = var.instance_ids
  }
}

data "aws_instance" "ireland_instance" {
  provider    = aws.ireland
  for_each    = toset(var.instance_ids)
  instance_id = each.value
}

# Fetch unique subnet IDs associated with the instances
data "aws_subnet" "ireland_subnet" {
  provider = aws.ireland
  for_each = toset(distinct([for instance in data.aws_instance.ireland_instance : instance.subnet_id]))
  id       = each.value
}

# Fetch unique VPC IDs based on the subnets
data "aws_vpc" "ireland_vpc" {
  provider = aws.ireland
  for_each = toset(distinct([for subnet in data.aws_subnet.ireland_subnet : subnet.vpc_id]))
  id       = each.value
}

# Fetch security groups associated with each instance
data "aws_security_group" "ireland_security_groups" {
  provider = aws.ireland
  for_each = {
    for instance_id in var.instance_ids :
    instance_id =>
    length(data.aws_instance.ireland_instance[instance_id].vpc_security_group_ids) > 0 ?
    tolist(data.aws_instance.ireland_instance[instance_id].vpc_security_group_ids)[0] : ""
  }
  id = each.value
}