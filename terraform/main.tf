terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  endpoints {
    sns = var.aws_endpoint
  }
}

resource "aws_sns_topic" "metrics_topic" {
  name = var.sns_topic_name
}

output "sns_topic_arn" {
  value = aws_sns_topic.metrics_topic.arn
}