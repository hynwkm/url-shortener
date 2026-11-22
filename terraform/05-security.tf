resource "aws_security_group" "web" {
  name        = "shorturl-web"
  description = "Apache public HTTPS and restricted SSH"
  vpc_id      = aws_vpc.main.id
  tags = { Name = "shorturl-web-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "in" {
  for_each = {
    "443" = "0.0.0.0/0"
    "80" = "0.0.0.0/0"
    "22" = var.admin_cidr
  }

  security_group_id = aws_security_group.web.id
  ip_protocol       = "tcp"
  from_port         = tonumber(each.key)
  to_port           = tonumber(each.key)
  cidr_ipv4         = each.value
}
