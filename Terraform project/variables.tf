variable "instance_ids" {
  description = "List of EC2 instance IDs to replicate"
  type        = list(string)
}

variable "source_region" {
  description = "AWS source region"
  type        = string
  default     = "eu-west-1" # Default to Ireland
}

variable "destination_region" {
  description = "AWS destination region"
  type        = string
}