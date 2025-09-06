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
    sqs = var.aws_endpoint
  }
}

# SNS Topic
resource "aws_sns_topic" "metrics_topic" {
  name = var.sns_topic_name
}

# SQS Queue
resource "aws_sqs_queue" "metrics_queue" {
  name = var.sqs_queue_name
}

# Policy para permitir que o SNS publique na fila SQS
resource "aws_sqs_queue_policy" "metrics_queue_policy" {
  queue_url = aws_sqs_queue.metrics_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "sqs:SendMessage"
        Resource = aws_sqs_queue.metrics_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.metrics_topic.arn
          }
        }
      }
    ]
  })
}

# Subscription SNS -> SQS
resource "aws_sns_topic_subscription" "metrics_subscription" {
  topic_arn = aws_sns_topic.metrics_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.metrics_queue.arn
}

output "sns_topic_arn" {
  value = aws_sns_topic.metrics_topic.arn
}

output "sqs_queue_url" {
  value = aws_sqs_queue.metrics_queue.id
}

output "sqs_queue_arn" {
  value = aws_sqs_queue.metrics_queue.arn
}