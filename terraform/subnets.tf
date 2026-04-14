# ---------------------------------------------------------
# Public Subnet (ap-northeast-1a)
# - ALB や NAT Gateway を配置するための公開サブネット
# - インターネットと直接通信できる
# - 構成図の 10.0.0.0/24 に対応
# ---------------------------------------------------------
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-a"
  }
}

# ---------------------------------------------------------
# Public Subnet (ap-northeast-1c)
# - Multi-AZ 構成のための 2 つ目の公開サブネット
# - ALB / NAT Gateway の冗長化に使用
# - 構成図の 10.0.2.0/24 に対応
# ---------------------------------------------------------
resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-c"
  }
}
# ---------------------------------------------------------
# Private Subnet (ap-northeast-1a)
# - EC2（アプリケーション層）や RDS を配置する非公開サブネット
# - インターネットへは NAT Gateway 経由で通信
# - 構成図の 10.0.1.0/24 に対応
# ---------------------------------------------------------
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "private-a"
  }
}

# ---------------------------------------------------------
# Private Subnet (ap-northeast-1c)
# - Multi-AZ 構成のための 2 つ目の非公開サブネット
# - EC2 / RDS の冗長化に使用
# - 構成図の 10.0.3.0/24 に対応
# ---------------------------------------------------------
resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "private-c"
  }
}
