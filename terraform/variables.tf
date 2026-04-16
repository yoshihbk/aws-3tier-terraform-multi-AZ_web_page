variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "azs" {
  type    = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "default_tags" {
  type = map(string)
  default = {
    Project = "3tier-architecture"
    Owner   = "Yoshihiro"
  }
}
# ---------------------------------------------------------
# RDS 認証情報（Terraform 変数）
# - RDSインスタンスの username / password を外部から受け取る
# - GitHubに平文を残さないため、terraform.tfvars で値を設定する
# - password は sensitive = true でマスクされる
# ---------------------------------------------------------
variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
