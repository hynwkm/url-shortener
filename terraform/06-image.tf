resource "aws_vpc_security_group_egress_rule" "out" {
  security_group_id = aws_security_group.web.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

locals {
  ubuntu_ami_path = join("/", [
    "/aws/service/canonical/ubuntu/server/24.04",
    "stable/current/amd64/hvm/ebs-gp3/ami-id"
  ])
}

data "aws_ssm_parameter" "ubuntu" {
  name = local.ubuntu_ami_path
}
