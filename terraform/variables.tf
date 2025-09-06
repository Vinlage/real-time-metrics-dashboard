variable "aws_endpoint" {
  type    = string
  default = "http://localstack:4566"
}

variable "sns_topic_name" {
  description = "Nome do tópico SNS"
  type        = string
  default     = "metrics-topic"
}

variable "sqs_queue_name" {
  type    = string
  default = "metrics-queue"
}