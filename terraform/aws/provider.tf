provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "devops-app"
      Environment = "dev"
      ManagedBy  = "Terraform"
    }
  }
}
