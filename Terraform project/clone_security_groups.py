import boto3
import json
import subprocess

def get_terraform_outputs():
    output = subprocess.run(['terraform', 'output', '-json'], capture_output=True, text=True)
    return json.loads(output.stdout)

def get_security_group_rules(ec2_client, sg_id):
    response = ec2_client.describe_security_groups(GroupIds=[sg_id])
    sg = response['SecurityGroups'][0]
    return sg['IpPermissions'], sg['IpPermissionsEgress']

def apply_sg_rules(ec2_client, sg_id, ingress_rules, egress_rules):
    if ingress_rules:
        ec2_client.authorize_security_group_ingress(GroupId=sg_id, IpPermissions=ingress_rules)
    if egress_rules:
        ec2_client.authorize_security_group_egress(GroupId=sg_id, IpPermissions=egress_rules)

# Fetch Terraform outputs
tf_outputs = get_terraform_outputs()
source_sgs = tf_outputs['source_security_group_ids']['value']
target_sgs = tf_outputs['target_security_group_ids']['value']

source_region = 'eu-west-1'  # Source region: Ireland
target_region = 'eu-west-2'  # Target region: London

source_ec2 = boto3.client('ec2', region_name=source_region)
target_ec2 = boto3.client('ec2', region_name=target_region)

for source_sg, target_sg in zip(source_sgs, target_sgs):
    ingress, egress = get_security_group_rules(source_ec2, source_sg)
    apply_sg_rules(target_ec2, target_sg, ingress, egress)
    print(f"Copied rules from {source_sg} to {target_sg}")
