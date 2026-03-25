variable "db_password" {
  description = "MySQL password"
  type        = string
  sensitive   = true
}
variable "env_name" {
  type        = string
  description = "Environment name."
}

variable "sns_topic_arn" {
  type        = string
  description = "SNS topic arn"
}
variable "slack_web_hook_url" {
  type        = string
  description = "Slack webhook url."
}
variable "lambda_function_arn" {
  type = string
  description = "Lambda function arn"
}
variable "alert_sns_topic_arn" {
  type        = string
  description = "SNS topic arn."
}


variable "comment" {
  type        = string
  description = "App"
}

variable "alb_dns_name" {
  type        = string
  description = "ALB DNS Endpoint"
}

variable "origin_id" {
  type        = string
  description = "Origin id"
}

variable "default_behavior_allowed_methods" {
  type        = list(string)
  description = "Default behaviour allow methods"
}

variable "default_behavior_cached_methods" {
  type        = list(string)
  description = "Default behaviour cached methods"
}

variable "default_behavior_forwarded_values_header" {
  type        = list(string)
  description = "Default behaviour forwarded value headers"
}