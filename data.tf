data "aws_prefix_list" "s3_pl" {
  name = "com.amazonaws.ap-northeast-1.s3"
}

data "aws_ami" "app" {                                                     # 第1引数=aws_amiを使用、第2引数=appサーバを指定
  most_recent = true                                                       # 検索条件に複数合致するものがあった場合、最新のものを選択
  owners      = ["self", "amazon"]                                         # 自分自身が登録したもの、及びAmazon公式のものを指定

  filter {
    name = "name"
    # values = [ "amzn2-ami-kernel-5.10-hvm-2.0.20220121.0-x86_64-gp2" ]   # AMIを指定
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*-x86_64-gp2"]                # 日付箇所を「*」とすることで複数のAMIをヒットさせる
  }

  filter {
    name   = "root-device-type"                                            # AWS-CLI: RootDeviceTypeを指定
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"                                         # AWS-CLI: VirtualizationTypeを指定
    values = ["hvm"]
  }
}
