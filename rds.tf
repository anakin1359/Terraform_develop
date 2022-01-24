# ---------------------------
# RDS parameter group
# ---------------------------
resource "aws_db_parameter_group" "mysql_standalone_parametergroup" {
  name   = "${var.project}-${var.environment}-mysql-standalone-parametergroup"
  family = "mysql8.0"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

# ---------------------------
# RDS option group
# ---------------------------
resource "aws_db_option_group" "mysql_standalone_optiongroup" {
  name                 = "${var.project}-${var.environment}-mysql-standalone-optiongroup"
  engine_name          = "mysql"
  major_engine_version = "8.0"
}

# ---------------------------
# RDS subnet group
# ---------------------------
resource "aws_db_subnet_group" "mysql_standalone_subnetgroup" {
  name = "${var.project}-${var.environment}-mysql-standalone-subnetgroup"
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]

  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone-subnetgroup"
    Project = var.project
    Env     = var.environment
  }
}

# ---------------------------
# RDS instance
# ---------------------------
resource "random_string" "db_password" {
  length  = 16
  special = false
}

resource "aws_db_instance" "mysql_standalone" {

  # 1. 基本設定
  engine         = "mysql"
  engine_version = "8.0"
  identifier     = "${var.project}-${var.environment}-mysql-standalone"
  username       = "admin"
  password       = random_string.db_password.result
  instance_class = "db.t2.micro"

  # 2. ストレージ設定
  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp2"
  storage_encrypted     = false

  # 3. ネットワーク設定
  multi_az               = false
  availability_zone      = "ap-northeast-1a"
  db_subnet_group_name   = aws_db_subnet_group.mysql_standalone_subnetgroup.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  port                   = 3306

  # 4. DB設定
  name                 = "tastylog"
  parameter_group_name = aws_db_parameter_group.mysql_standalone_parametergroup.name
  option_group_name    = aws_db_option_group.mysql_standalone_optiongroup.name

  # 5. バックアップ設定
  backup_window              = "04:00-05:00"
  backup_retention_period    = 7
  maintenance_window         = "Mon:05:00-Mon:08:00"
  auto_minor_version_upgrade = false

  # # 6. 削除防止設定(通常時)
  # deletion_protection = true                                                           # 削除防止を行う
  # skip_final_snapshot = false                                                          # 削除時のスナップショットをスキップしない（スナップショットを取得する）
  # apply_immediately   = true                                                           # 削除実行時に即時反映させる

  # 6. 削除防止設定(削除時)
  deletion_protection = false                                                            # 削除防止を行わない
  skip_final_snapshot = true                                                             # 削除時のスナップショットをスキップする（スナップショットを取得しない）
  apply_immediately   = true                                                             # 削除実行時に即時反映させる

  # 7. タグ設定
  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone"
    Project = var.project
    Env     = var.environment
  }
}
