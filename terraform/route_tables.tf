# ---------------------------------------------------------
# Internet Gateway
# - Public Subnet からインターネットへ出るためのゲートウェイ
# - Public Route Table のデフォルトルートの宛先になる
# ---------------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# ---------------------------------------------------------
# Public Route Table
# - Public Subnet がインターネットへ出るためのルートを保持
# - 0.0.0.0/0 → Internet Gateway という経路を設定
# ---------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-rt"
  }
}

# ---------------------------------------------------------
# Public Route
# - 全トラフィック（0.0.0.0/0）を IGW に向ける
# - Public Subnet がインターネットと通信可能になる
# ---------------------------------------------------------
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# ---------------------------------------------------------
# Route Table Association (public-a)
# - Public Subnet (10.0.0.0/24) を Public Route Table に紐づける
# ---------------------------------------------------------
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

# ---------------------------------------------------------
# Route Table Association (public-c)
# - Public Subnet (10.0.2.0/24) を Public Route Table に紐づける
# ---------------------------------------------------------
resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}


# ---------------------------------------------------------
# Elastic IP for NAT Gateway
# - NAT Gateway がインターネットへ出るために必要な固定パブリックIP
# - Private Subnet の外向き通信は NAT Gateway 経由で行われるため必須
# ---------------------------------------------------------
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "nat-eip"
  }
}

# ---------------------------------------------------------
# NAT Gateway
# - Private Subnet がインターネットへ出るための中継ポイント
# - Public Subnet 内に配置する必要がある（AWS の仕様）
# - 今回は public-a に配置（AZ 冗長は後で NAT Gateway を増やす構成も可能）
# ---------------------------------------------------------
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "nat-gateway"
  }
}

# ---------------------------------------------------------
# Private Route Table
# - Private Subnet が NAT Gateway 経由でインターネットへ出るためのルートを保持
# - 0.0.0.0/0 のデフォルトルートを NAT Gateway に向ける
# ---------------------------------------------------------
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-rt"
  }
}

# ---------------------------------------------------------
# Private Route
# - 全トラフィック（0.0.0.0/0）を NAT Gateway に向ける
# - Private Subnet 内の EC2 が yum / apt / 外部API などへアクセス可能になる
# ---------------------------------------------------------
resource "aws_route" "private_nat_access" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# ---------------------------------------------------------
# Route Table Association (private-a)
# - Private Subnet (10.0.1.0/24) を Private Route Table に紐づける
# ---------------------------------------------------------
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

# ---------------------------------------------------------
# Route Table Association (private-c)
# - Private Subnet (10.0.3.0/24) を Private Route Table に紐づける
# ---------------------------------------------------------
resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private.id
}
