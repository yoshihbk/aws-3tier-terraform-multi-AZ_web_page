# ---------------------------------------------------------
# RDS MySQL Instance
# ---------------------------------------------------------
resource "aws_db_instance" "mysql" {
  identifier              = "my-mysql"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20

  # 認証情報（variables.tf で変数化）
  username                = var.db_username
  password                = var.db_password

  # ネットワーク設定
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]

  # セキュリティ
  publicly_accessible     = false
  multi_az                = true

  # 自動バックアップ
  backup_retention_period = 7

  # 削除保護（本番では true）
  deletion_protection     = false

  skip_final_snapshot     = true

  tags = {
    Name = "mysql-instance"
  }
}
