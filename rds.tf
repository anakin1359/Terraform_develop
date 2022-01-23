# ---------------------------
# RDS parameter group
# ---------------------------
resource "aws_db_parameter_group" "mysql_standalone_parametergroup" {
  name   = "${var.project}-${var.environment}-mysql-standalone-parametergroup"
  family = "mysql8.0"                                                            # MySQLの種類を指定

  # データベース用のパラメータグループを設定
  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  # サーバ用のパラメータグループを設定
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}
