resource "aws_subnet" "replicated_subnet" {
  provider = aws.destination
  for_each = data.aws_subnet.ireland_subnet

  cidr_block = each.value.cidr_block
  vpc_id     = aws_vpc.replicated_vpc[each.value.vpc_id].id
  tags = {
    Name = "Replicated-Subnet-${each.value.tags["Name"]}"
  }
}