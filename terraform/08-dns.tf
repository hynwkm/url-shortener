# 탄력적 IP, DNS 레코드 및 출력값

# 고정 공인 IPv4 주소(Elastic IP)를 할당하고 EC2에 연결합니다.
resource "aws_eip" "web" {
  domain     = "vpc"
  instance = aws_instance.web.id
  # 인터넷 게이트웨이 생성 이후에 EIP를 처리하도록 의존성을 지정합니다.
  depends_on = [aws_internet_gateway.igw]
  tags = { Name = "shorturl-eip" }
}

# 기존 호스팅 영역에 웹 서버의 DNS 레코드를 생성합니다.
resource "aws_route53_record" "web" {
  zone_id = var.zone_id
  name    = var.fqdn
  # 도메인 이름을 IPv4 주소에 연결하는 A 레코드입니다.
  type    = "A"
  # DNS 응답의 캐시 유지 시간은 300초입니다.
  ttl     = 300
  records = [aws_eip.web.public_ip]
}

# 배포 후 EC2 공인 IP를 터미널에 출력합니다. SSH 접속에 사용합니다.
output "web_ip" {
  description = "Public Elastic IP of the Apache EC2 instance"
  value       = aws_eip.web.public_ip
}

# 웹 사이트의 예정 HTTPS 주소를 출력합니다. 인증서 설치 여부를 검증하지는 않습니다.
output "website_url" {
  value = "https://${var.fqdn}"
}
