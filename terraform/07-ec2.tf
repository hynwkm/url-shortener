resource "aws_instance" "web" {
  ami                         = data.aws_ssm_parameter.ubuntu.value
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.web.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  key_name                    = var.key_name
  associate_public_ip_address = false

  depends_on = [
    aws_route_table_association.web,
    aws_vpc_security_group_egress_rule.out
  ]

  # 초기 부팅 시 Tailscale, Apache 및 HTTPS 자동 설정
  user_data_replace_on_change = true
  user_data                   = <<-EOF_SCRIPT
    #!/bin/bash
    set -euo pipefail
    export DEBIAN_FRONTEND=noninteractive
    DOMAIN=${jsonencode(trimsuffix(var.fqdn, "."))}
    # EIP 연결 및 인터넷 통신이 가능해질 때까지 재시도
    installed=0
    for i in {1..30}; do
      if apt-get update -o APT::Update::Error-Mode=any && apt-get install -y apache2 certbot python3-certbot-apache dnsutils curl; then
        installed=1
        break
      fi
      sleep 15
    done
    test "$installed" = 1

    # Tailscale 설치: HTTPS 인증서 발급 전에 원격 접속을 준비합니다.
    tailscale_installed=0
    for i in {1..10}; do
      if curl -fsSL --connect-timeout 10 --max-time 120 \
        https://tailscale.com/install.sh -o /tmp/install-tailscale.sh \
        && sh /tmp/install-tailscale.sh; then
        tailscale_installed=1
        break
      fi
      sleep 15
    done
    rm -f /tmp/install-tailscale.sh
    test "$tailscale_installed" = 1
    systemctl enable --now tailscaled

    # 키를 로그에 출력하지 않습니다. 키는 state/user data에는 포함됩니다.
    set +x
    TAILSCALE_AUTH_KEY='${var.tailscale_auth_key}'
    tailscale_connected=0
    for i in {1..10}; do
      if tailscale up --auth-key="$TAILSCALE_AUTH_KEY" --timeout=30s; then
        tailscale_connected=1
        break
      fi
      sleep 15
    done
    unset TAILSCALE_AUTH_KEY
    test "$tailscale_connected" = 1
    echo 'Tailscale setup complete'

    # Apache 가상 호스트 설정
    cat > /etc/apache2/sites-available/shorturl.conf <<VHOST
    <VirtualHost *:80>
        ServerName $DOMAIN
        DocumentRoot /var/www/html
    </VirtualHost>
    VHOST
    a2dissite 000-default.conf
    a2ensite shorturl.conf
    apache2ctl configtest
    systemctl enable --now apache2
    systemctl reload apache2

    # DNS가 현재 EC2의 EIP를 가리킬 때까지 대기 (IMDSv2)
    ready=0
    for i in {1..60}; do
      TOKEN=$(curl -fsS --max-time 5 -X PUT http://169.254.169.254/latest/api/token -H 'X-aws-ec2-metadata-token-ttl-seconds: 60' || true)
      IP=$(curl -fsS --max-time 5 -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4 || true)
      if [ -n "$IP" ] && [ "$(dig +short +time=3 +tries=1 A "$DOMAIN" @1.1.1.1 | sort -u)" = "$IP" ]; then
        ready=1
        break
      fi
      sleep 15
    done
    test "$ready" = 1

    # Let's Encrypt 인증서 발급 및 HTTP -> HTTPS 자동 전환
    certbot --apache --non-interactive --agree-tos --register-unsafely-without-email --redirect -d "$DOMAIN"
    systemctl enable --now certbot.timer
    apache2ctl configtest
    curl -fsS --max-time 15 --resolve "$DOMAIN:443:127.0.0.1" "https://$DOMAIN/" >/dev/null
    echo 'HTTPS setup complete'
  EOF_SCRIPT

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

