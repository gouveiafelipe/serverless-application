locals {

  lambda_path = "${path.module}/../app/lambdas"

  common_tags = {
    Project   = "Teemo CRUD Serverless App"
    CreatedAt = "2022-10-18"
    ManagedBy = "Terraform"
    Owner     = "Felipe Gouveia"
    Service   = var.service_name
  }
}

