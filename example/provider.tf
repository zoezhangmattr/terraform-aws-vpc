provider "aws" {
  # i am using environment variables locally
  region = "us-east-1"
  # access_key = "AKIAZGWEKBAWRKPVLRIL"
  # secret_key = "my-secret-key"
  default_tags {
    tags = {
      Provisioner = "Terraform"
      Project     = "POC"
      OWNER       = "ops"
    }
  }
}
