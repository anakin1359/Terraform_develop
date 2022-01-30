# ---------------------------
# Key paair
# ---------------------------
resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-${var.environment}-keypair"
  public_key = file("./src/tastylog-dev-keypair.pub") # [必須] 「fileメソッド」を使用して公開鍵のパスを指定

  tags = {
    Name    = "${var.project}-${var.environment}-keypair"
    Project = var.project
    Env     = var.environment
  }
}

# ---------------------------
# EC2 Instance
# ---------------------------
resource "aws_instance" "app_server" {

  # 1. 基本設定
  ami           = data.aws_ami.app.id # AMIのIDIDを指定
  instance_type = "t2.micro"

  # 2. NW設定
  subnet_id                   = aws_subnet.public_subnet_1a.id # サブネットID
  associate_public_ip_address = true                           # 自動割り当てパブリックID
  vpc_security_group_ids = [
    aws_security_group.app_sg.id,  # セキュリティグループID（APPサーバ用）
    aws_security_group.opmng_sg.id # セキュリティグループID（運用管理サーバ用）
  ]

  # 3. その他設定
  key_name = aws_key_pair.keypair.key_name # 使用するキーペアを指定
  tags = {
    Name    = "${var.project}-${var.environment}-app-ec2"
    Project = var.project
    Env     = var.environment
    Type    = "app" # 環境変数として読み込ませるための設定
  }
}
