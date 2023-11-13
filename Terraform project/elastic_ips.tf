resource "aws_eip" "replicated_instance_eip" {
  provider = aws.destination
  for_each = data.aws_instance.ireland_instance

  instance = aws_instance.replicated_instance[each.key].id
  domain   = "vpc"
}
