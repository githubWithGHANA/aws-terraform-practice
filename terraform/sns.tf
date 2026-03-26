resource "aws_sns_topic" "error_alert_topic" {
  name = "nit-${var.env_name}-alert-topic"
}

resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.error_alert_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.cloudwatch_sns_to_slack_notification
}