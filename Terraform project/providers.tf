provider "aws" {
  region = var.source_region
  alias  = "ireland"
}

provider "aws" {
  region = var.destination_region 
  alias  = "destination"
}