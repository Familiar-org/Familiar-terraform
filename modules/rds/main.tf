locals {
  db_engine         = ""
  db_engine_version = ""
}

resource "aws_db_instance" "rds" {
  allocated_storage = var.db_storage_size
  storage_type      = var.db_storage_type
  engine            = local.db_engine
  engine_version    = local.db_engine_version
  instance_class    = var.db_class
  username          = var.db_username
  password          = var.db_password

  vpc_security_group_ids = aws_db_subnet_group.rds.subnet_ids
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  skip_final_snapshot    = true // required to destroy
}

resource "aws_db_subnet_group" "rds" {
  subnet_ids = [var.private_db_subnet_ids]
  name       = var.subnet_group_name
}
