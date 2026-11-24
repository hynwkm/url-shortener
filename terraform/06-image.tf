# 아웃바운드 규칙 및 Ubuntu AMI 조회

# EC2에서 외부로 나가는 트래픽 규칙입니다. 패키지 설치 등에 필요합니다.
resource "aws_vpc_security_group_egress_rule" "out" {
  security_group_id = aws_security_group.web.id
  # 모든 IP 프로토콜을 허용합니다.
  ip_protocol       = "-1"
  # 모든 IPv4 목적지로의 아웃바운드를 허용합니다.
  cidr_ipv4         = "0.0.0.0/0"
}

# 이 Terraform 구성 내부에서 재사용할 값을 정의합니다.
locals {
  # 두 문자열을 /로 연결해 Ubuntu 공식 AMI의 SSM 파라미터 경로를 만듭니다.
  ubuntu_ami_path = join("/", [
    "/aws/service/canonical/ubuntu/server/24.04",
    # 안정 버전의 최신 x86-64 HVM / gp3 AMI를 가리킵니다.
    "stable/current/amd64/hvm/ebs-gp3/ami-id"
  ])
}

# SSM에서 기존 공개 파라미터를 조회합니다. 새 AMI를 생성하지 않습니다.
data "aws_ssm_parameter" "ubuntu" {
  name = local.ubuntu_ami_path
}
