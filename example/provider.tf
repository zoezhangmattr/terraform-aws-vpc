provider "aws" {
  default_tags {
    tags = {
      Provisioner = "Terraform"
      Project     = "POC"
    }
  }
}
