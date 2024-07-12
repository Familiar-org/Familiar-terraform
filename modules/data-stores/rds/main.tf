resource "aws_db_instance" "rds" {
  allocated_storage = var.db_storage_size
  storage_type      = var.db_storage_type
  engine            = var.db_engine
  engine_version    = var.db_engine_version
  instance_class    = var.db_class
  username          = var.db_username
  password          = var.db_password

  vpc_security_group_ids = aws_db_subnet_group.rds_subnet_group.subnet_ids
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot    = true // required to destroy
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  subnet_ids = [aws_subnet.private_db_subnet.id]
}
