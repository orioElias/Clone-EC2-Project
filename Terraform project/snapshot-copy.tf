resource "aws_ebs_snapshot_copy" "snapshot_copy" {
  provider           = aws.destination
  for_each           = data.external.instance_snapshots.result
  source_snapshot_id = jsondecode(each.value)["snapshot_id"]
  source_region      = var.source_region
  
  tags = {
    Name = "Snapshot Copy of ${each.key}"
  }
}