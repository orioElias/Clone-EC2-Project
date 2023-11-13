resource "aws_vpc" "replicated_vpc" {
  provider = aws.destination
  for_each = data.aws_vpc.ireland_vpc

  cidr_block = each.value.cidr_block
  tags = {
    # Use the Name tag from the source VPC
    Name = "Replicated-${each.value.tags["Name"]}"
  }
}