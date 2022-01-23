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
  identifier     = "${var.project}-${var.environment}-mysql-standalone"                # RDSを識別する一意の名前となる
  username       = "admin"
  password       = random_string.db_password.result                                    # 生成したランダム文字列を使用(属性名resultについて？)
  instance_class = "db.t2.micro"

  # 2. ストレージ設定
  allocated_storage     = 20                                                           # 初期のストレージ容量を指定（単位:ギガバイト）
  max_allocated_storage = 50                                                           # オートスケールで最大拡張容量を指定（単位: ギガバイト）
  storage_type          = "gp2"                                                        # default => gp2
  storage_encrypted     = false                                                        # ストレージの暗号化は行わない（処理が重くなるため）

  # 3. ネットワーク設定
  multi_az               = false                                                       # マルチAZ構成にはしない
  availability_zone      = "ap-northeast-1a"                                           # シングルAZ構成のためアベイラビリティゾーンを指定
  db_subnet_group_name   = aws_db_subnet_group.mysql_standalone_subnetgroup.name       # このDBが所属するサブネットグループを指定
  vpc_security_group_ids = [aws_security_group.db_sg.id]                               # このDBにアタッチするVPCセキュリティグループを指定
  publicly_accessible    = false                                                       # パブリックでのアクセスは許可しない
  port                   = 3306

  # 4. DB設定
  name                 = "tastylog"
  parameter_group_name = aws_db_parameter_group.mysql_standalone_parametergroup.name
  option_group_name    = aws_db_option_group.mysql_standalone_optiongroup.name

  # 5. バックアップ設定
  backup_window              = "04:00-05:00"                                           # メンテナンス実行前にバックアップを取得
  backup_retention_period    = 7                                                       # 何日分バックアップを保管するか（1週間分保管する設定）
  maintenance_window         = "Mon:05:00-Mon:08:00"                                   # メンテナンスの実行タイミングを指定
  auto_minor_version_upgrade = false                                                   # マイナーアップデートは許可しない

  # 6. 削除防止設定
  deletion_protection = true                                                           # 自動で削除はさせない
  skip_final_snapshot = false                                                          # 削除時のスナップショットをスキップしない（スナップショットを取得する）
  apply_immediately   = true                                                           # 削除実行時に即時反映させる

  # 7. タグ設定
  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone"
    Project = var.project
    Env     = var.environment
  }
}
