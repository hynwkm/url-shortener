# 보안 그룹 및 인바운드 규칙

# EC2의 가상 방화벽인 보안 그룹을 생성합니다.
resource "aws_security_group" "web" {
  name        = "shorturl-web"
  description = "Apache public HTTPS and restricted SSH"
  vpc_id      = aws_vpc.main.id
  tags = { Name = "shorturl-web-sg" }
}

# 외부에서 EC2로 들어오는 트래픽을 허용하는 규칙을 생성합니다.
resource "aws_vpc_security_group_ingress_rule" "in" {
  for_each = {
    # HTTPS: 모든 IPv4 사용자에게 암호화 웹 접속 허용.
    "443" = "0.0.0.0/0"
    # HTTP: 모든 IPv4 사용자에게 웹 접속 허용. 인증서 검증에도 사용됩니다.
    "80" = "0.0.0.0/0"
    # SSH: 관리자 IP 범위에서만 원격 접속 허용.
    "22" = var.admin_cidr
  }

  security_group_id = aws_security_group.web.id
  ip_protocol       = "tcp"
  # each.key의 문자열 포트를 숫자로 변환하여 시작 포트로 지정합니다.
  from_port         = tonumber(each.key)
  to_port           = tonumber(each.key)
  # each.value에서 해당 포트의 허용 IP 범위를 가져옵니다.
  cidr_ipv4         = each.value
}
