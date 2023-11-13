resource "aws_instance" "replicated_instance" {
  provider = aws.destination
  depends_on = [aws_ami.new_ami]
  for_each = data.aws_instance.ireland_instance
  ami                    = aws_ami.new_ami[each.key].id
  instance_type          = each.value.instance_type
  subnet_id              = aws_subnet.replicated_subnet[data.aws_instance.ireland_instance[each.key].subnet_id].id
  vpc_security_group_ids = [aws_security_group.replicated_security_group[each.key].id]

  tags = {
    Name   = "Replicated-Instance-${each.value.tags["Name"]}"
    Origin = "Ireland"
  }
}

resource "null_resource" "execute_script" {
  depends_on = [aws_instance.replicated_instance, aws_security_group.replicated_security_group]

  provisioner "local-exec" {
    command = "python3 clone_security_groups.py"
  }
}