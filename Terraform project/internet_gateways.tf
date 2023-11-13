resource "aws_internet_gateway" "replicated_igw" {
  provider = aws.destination
  for_each = aws_vpc.replicated_vpc

  vpc_id = each.value.id

  tags = {
    Name = "Replicated-IGW-${each.value.tags["Name"]}"
  }
}

resource "aws_route" "internet_access" {
  provider = aws.destination
  for_each = aws_vpc.replicated_vpc

  route_table_id         = each.value.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.replicated_igw[each.key].id
}
