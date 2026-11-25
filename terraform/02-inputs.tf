# 외부 입력 변수 선언

# 기존 EC2 키 페어 이름을 입력받습니다. PEM 파일 경로가 아닙니다.
variable "key_name" {
  type = string
}

# SSH 접속을 허용할 관리자 공인 IP 대역을 입력받습니다.
variable "admin_cidr" {
  type = string
}

# 기존 Route 53 퍼블릭 호스팅 영역 ID를 입력받습니다.
variable "zone_id" {
  type = string
}

# 웹 서버에 연결할 전체 도메인 이름을 입력받습니다.
variable "fqdn" {
  type = string
}

# 리전 이름을 입력받습니다.
variable "region_name" {
  type = string
}

# TailScale 키값 입력.
variable "tailscale_auth_key" {
  description = "Tailscale authentication key"
  type        = string
  sensitive   = true
}
