# 인터넷 경로 및 서브넷 연결

# 서브넷의 네트워크 트래픽이 어디로 이동할지 정의합니다.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    # 모든 IPv4 목적지에 대한 기본 경로입니다. 더 구체적인 경로가 우선합니다.
    cidr_block = "0.0.0.0/0"
    # 기본 경로의 목적지를 인터넷 게이트웨이로 지정합니다.
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "shorturl-public-rt" }
}

# 웹 서브넷에 위 라우팅 테이블을 연결합니다.
resource "aws_route_table_association" "web" {
  subnet_id      = aws_subnet.web.id
  route_table_id = aws_route_table.public.id
}
