data "external" "instance_snapshots" {
  program = ["/usr/bin/python3", "${path.module}/get_snapshots_ids.py", join(",", var.instance_ids), var.source_region]
}

locals {
  instance_details = { for k, v in data.external.instance_snapshots.result : k => jsondecode(v) }
}

resource "aws_ami" "new_ami" {
  provider = aws.destination
  for_each = data.external.instance_snapshots.result

  name                = "AMI from Copied Snapshot ${aws_ebs_snapshot_copy.snapshot_copy[each.key].id}"
  virtualization_type = local.instance_details[each.key].virtualization_type
  root_device_name    = local.instance_details[each.key].root_device_name

  ebs_block_device {
    snapshot_id           = aws_ebs_snapshot_copy.snapshot_copy[each.key].id
    device_name           = local.instance_details[each.key].root_device_name
    volume_size           = tonumber(local.instance_details[each.key].volume_size)
    volume_type           = local.instance_details[each.key].volume_type
    delete_on_termination = local.instance_details[each.key].delete_on_termination == "True"
  }
}
