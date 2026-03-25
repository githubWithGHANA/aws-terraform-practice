output "nlb_dns" {
  description = "Internal NLB DNS — point your FE to this"
  value       = aws_lb.nlb.dns_name
}

output "rds_endpoint" {
  description = "RDS endpoint (auto-stored in SSM /nit/dev/mysql/host)"
  value       = aws_db_instance.mysql.address
}

output "private_subnet_1_id" {
  value = aws_subnet.private_1.id
}

output "private_subnet_2_id" {
  value = aws_subnet.private_2.id
}

output "nat_gateway_public_ip" {
  value = aws_eip.nat_eip.public_ip
}

output "sns_topic_arn" {
  value = aws_sns_topic.error_alert_topic.arn
}
output "lambda_function_arn" {
  value = aws_lambda_function.cloudwatch_sns_to_slack_notification.arn
}