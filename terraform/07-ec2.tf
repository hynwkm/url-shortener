resource "aws_instance" "web" {
  ami                         = data.aws_ssm_parameter.ubuntu.value
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.web.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  key_name                    = var.key_name
  associate_public_ip_address = false

  # 인터넷 경로와 아웃바운드 규칙을 먼저 생성
  depends_on = [
    aws_route_table_association.web,
    aws_vpc_security_group_egress_rule.out
  ]

  # 최초 부팅 시 Apache 자동 설치 (EIP 연결 전이면 재시도)
  user_data = <<-EOF
    #!/bin/bash
    set -e
    export DEBIAN_FRONTEND=noninteractive

    for i in {1..30}; do
      if apt-get update -o APT::Update::Error-Mode=any && apt-get install -y apache2; then
        systemctl enable --now apache2
        exit 0
      fi
      sleep 10
    done

    echo "Apache installation failed" >&2
    exit 1
  EOF

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 12
    encrypted   = true
  }

  tags = { Name = "shorturl-apache" }
}
