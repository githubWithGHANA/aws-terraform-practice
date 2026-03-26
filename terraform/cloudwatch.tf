resource "time_sleep" "wait_time" {
  create_duration = "60s"
}
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/datastore/app"
  retention_in_days = 1
}


resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  depends_on     = [time_sleep.wait_time]
  name           = "nit-${var.env_name}-error-count-filter"
  log_group_name = aws_cloudwatch_log_group.app_logs.name

  pattern = "ERROR"

  metric_transformation {
    name      = "AppErrorCount"
    namespace = "AppLogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "error_alarm" {
  alarm_name          = "nit-${var.env_name}-error-count-alarm"
  alarm_description   = "Triggered when error keyword appears in logs"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  period              = 30
  threshold           = 1

  metric_name = aws_cloudwatch_log_metric_filter.error_filter.metric_transformation[0].name
  namespace   = aws_cloudwatch_log_metric_filter.error_filter.metric_transformation[0].namespace
  statistic   = "Sum"

  alarm_actions = [
    aws_sns_topic.error_alert_topic.arn
  ]
}