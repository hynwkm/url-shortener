# EC2 인스턴스 생성

# Ubuntu 웹 서버용 EC2 인스턴스를 생성합니다. Apache는 별도 설치합니다.
resource "aws_instance" "web" {
  ami                         = data.aws_ssm_parameter.ubuntu.value
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.web.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  key_name                    = var.key_name
  # 일반 공인 IP 자동 할당을 끕니다. EIP는 08-dns.tf에서 연결합니다.
  associate_public_ip_address = false

  metadata_options {
    # IMDSv2 토큰 사용을 강제하여 메타데이터 접근 보안을 강화합니다.
    http_tokens = "required"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 12
    # EBS 볼륨 암호화를 활성화합니다.
    encrypted   = true
  }

  tags = { Name = "shorturl-apache" }
}
