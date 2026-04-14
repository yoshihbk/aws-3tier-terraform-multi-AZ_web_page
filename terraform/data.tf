# ---------------------------------------------------------
# Get latest Amazon Linux 2023 AMI from SSM Parameter Store
# - 最新 AMI を自動取得するのがモダン構成
# ---------------------------------------------------------
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}
