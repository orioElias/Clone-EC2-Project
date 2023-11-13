
# Clone EC2 Project

## Overview
The Clone EC2 Project automates the replication of AWS EC2 instances from one region (default: Ireland) to any target AWS region. It ensures that associated resources like security groups, VPC settings, and static IP assignments are also replicated.

## Requirements
- Python installed
- `boto3` Python library installed
- AWS credentials configured to manage required resources in AWS

## Usage Instructions
1. **Setup Backend Resources:**
   - Navigate to the `setup` directory.
   - Run `terraform init` and `terraform apply` to create an S3 bucket for Terraform state management and a DynamoDB table for state locking.
2. **Main Terraform Configuration:**
   - In the root directory, run `terraform init` and `terraform apply`.
   - In `terraform.tfvars`, enter the EC2 instance IDs you wish to clone and the destination AWS region.

   ```hcl
   instance_ids = ["i-0926c838b390e7534"]
   destination_region = "eu-west-2"
   ```

   _Note: The default source region is Ireland (eu-west-1). To change it, use `--var='source_region=desired-region'` with the `terraform apply` command._

3. **Resource Creation:**
   - Terraform will clone the specified EC2 instances to the desired region considering security groups, VPCs, static IPs, instance types, and other attributes.
   - Each new instance will have an additional tag: `Origin: Ireland`.

## S3 and DynamoDB Resources
- An S3 bucket (`terraform-project-state-bucket`) is used to store the Terraform state files.
- A DynamoDB table (`lock-table`) is used for state locking to prevent concurrent operations on the same state.

## AWS Elastic IP Limitation
- AWS regions typically allow a maximum of 5 Elastic IPs. If your project requires more, you'll need to request additional IPs from AWS.

## Python Scripts
- `clone_security_groups.py`: Clones security group rules from source to destination region.
- `get_snapshots_ids.py`: Responsible for creating snapshots of specified EC2 instances in the source region. Subsequent actions such as copying these snapshots to the destination region and creating AMIs are handled by Terraform configuration.

## Repository Structure
The project is organized into a directory (`terraform_project`) with multiple Terraform configuration files and Python scripts:

```
terraform_project/
├── ami-creation.tf
├── backend.tf
├── clone_security_groups.py
├── data-sources.tf
├── elastic_ips.tf
├── get_snapshots_ids.py
├── instances.tf
├── internet_gateways.tf
├── outputs.tf
├── providers.tf
├── security-groups.tf
├── setup_S3_Backend/
│   ├── dynamodb.tf
│   └── s3_bucket.tf
├── snapshot-copy.tf
├── subnets.tf
├── terraform.tfvars
├── variables.tf
└── vpcs.tf
```
