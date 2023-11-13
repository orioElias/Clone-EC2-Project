terraform {
  backend "s3" {
    bucket         = "unique-terraform-project-state-bucket-12345"
    key            = "terraform/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "lock-table"
    encrypt        = true
  }
}
