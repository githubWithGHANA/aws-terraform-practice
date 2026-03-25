# RDS — MySQL in private subnets
# Required: userdata does jdbc:mysql://$MYSQL_HOST:3306/datastore
###############################################################

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "nit-dev-db-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  tags       = { Name = "nit-dev-db-subnet-group" }
}

resource "aws_db_instance" "mysql" {
  identifier             = "nit-dev-mysql"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "datastore"
  username               = "nitadmin"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
  storage_encrypted      = true

  tags = { Name = "nit-dev-mysql" }
}