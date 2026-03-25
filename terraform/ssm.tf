resource "aws_ssm_parameter" "mysql_host" {
  name  = "/nit/dev/mysql/host"
  type  = "String"
  value = aws_db_instance.mysql.address
}

resource "aws_ssm_parameter" "mysql_username" {
  name  = "/nit/dev/mysql/username"
  type  = "String"
  value = "nitadmin"
}

resource "aws_ssm_parameter" "mysql_password" {
  name  = "/nit/dev/mysql/password"
  type  = "SecureString"
  value = var.db_password
}