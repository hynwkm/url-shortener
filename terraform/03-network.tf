# VPC, 서브넷, 인터넷 게이트웨이 생성

# AWS 내부에 독립적인 가상 네트워크(VPC)를 생성합니다.
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = { Name = "shorturl-vpc" }
}

# 웹 서버가 배치될 서브넷을 생성합니다.
resource "aws_subnet" "web" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  # 인스턴스에 공인 IP를 자동 할당하지 않습니다. 뒤에서 EIP를 연결합니다.
  map_public_ip_on_launch = false
  tags = { Name = "shorturl-public" }
}

# VPC와 인터넷 사이의 통신 통로(IGW)를 생성하고 VPC에 연결합니다.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "shorturl-igw" }
}
