resource "aws_eip" "web" {
  domain     = "vpc"
  instance = aws_instance.web.id
  depends_on = [aws_internet_gateway.igw]
  tags = { Name = "shorturl-eip" }
}

resource "aws_route53_record" "web" {
  zone_id = var.zone_id
  name    = var.fqdn
  type    = "A"
  ttl     = 300
  records = [aws_eip.web.public_ip]
}

output "web_ip" {
  description = "Public Elastic IP of the Apache EC2 instance"
  value       = aws_eip.web.public_ip
}

output "website_url" {
  value = "https://${var.fqdn}"
}
