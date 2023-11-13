output "source_security_group_ids" {
  value = [for sg in data.aws_security_group.ireland_security_groups : sg.id]
}

output "target_security_group_ids" {
  value = [for sg in aws_security_group.replicated_security_group : sg.id]
}

output "replicated_instance_eips" {
  value = { for key, eip in aws_eip.replicated_instance_eip : key => eip.public_ip }
}