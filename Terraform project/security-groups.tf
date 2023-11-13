resource "aws_security_group" "replicated_security_group" {
  provider = aws.destination
  for_each = data.aws_security_group.ireland_security_groups

  name        = "Replicated-${each.value.name}"
  description = "Replicated Security Group from ${each.value.id}"
  vpc_id      = aws_vpc.replicated_vpc[each.value.vpc_id].id

  tags = {
    Name = "Replicated-${each.value.name}"
  }
}
