import boto3
import json
import sys
import time

def create_snapshot(ec2, volume_id, instance_id):
    snapshot = ec2.create_snapshot(VolumeId=volume_id, Description=f"Auto-created snapshot for {instance_id}")
    snapshot_id = snapshot['SnapshotId']
    time.sleep(15)  # Simple wait, can be improved
    return snapshot_id

def get_instance_details(instance_ids, region):
    ec2 = boto3.client('ec2', region_name=region)
    instances = ec2.describe_instances(InstanceIds=instance_ids)['Reservations']
    instance_details = {}

    for reservation in instances:
        for instance in reservation['Instances']:
            volume_id = instance['BlockDeviceMappings'][0]['Ebs']['VolumeId']
            snapshot_id = instance['BlockDeviceMappings'][0]['Ebs'].get('SnapshotId')
            if not snapshot_id:
                snapshot_id = create_snapshot(ec2, volume_id, instance['InstanceId'])

            volume_info = ec2.describe_volumes(VolumeIds=[volume_id])['Volumes'][0]
            details = {
                'snapshot_id': str(snapshot_id),
                'instance_type': str(instance.get('InstanceType')),
                'availability_zone': str(instance['Placement']['AvailabilityZone']),
                'virtualization_type': str(instance.get('VirtualizationType', 'hvm')),
                'root_device_name': str(instance.get('RootDeviceName', '/dev/sda1')),
                'volume_size': str(volume_info['Size']),
                'volume_type': str(volume_info['VolumeType']),
                'delete_on_termination': str(instance['BlockDeviceMappings'][0]['Ebs'].get('DeleteOnTermination', True))
            }
            instance_details[instance['InstanceId']] = json.dumps(details)

    return json.dumps(instance_details)

if __name__ == "__main__":
    instance_ids = sys.argv[1].split(',')
    region = sys.argv[2]
    snapshot_details = get_instance_details(instance_ids, region)
    print(snapshot_details)
