
#!/bin/bash
set -euo pipefail

# 프로젝트 최상위 경로
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

DB_COMPOSE="$ROOT_DIR/docker/mariadb/compose.yaml"
WAS_COMPOSE="$ROOT_DIR/docker/Tomcat/compose.yaml"
ENV_FILE="$ROOT_DIR/.env"

echo "===== 1. 환경 확인 ====="

if [ ! -f "$ENV_FILE" ]; then
  echo ".env 파일이 없습니다."
  exit 1
fi

echo "===== 1.5. 호스트 이름 변경 ====="
set -a
source "$ENV_FILE"
set +a

sudo hostnamectl hostname "$TOMCAT_HOSTNAME"

echo "===== 2. Docker 네트워크 확인 ====="

if ! docker network inspect shorturl-network >/dev/null 2>&1; then
  docker network create shorturl-network
  echo "shorturl-network 생성 완료"
else
  echo "기존 shorturl-network 사용"
fi

echo "===== 3. MariaDB 실행 ====="

docker compose \
  --env-file "$ENV_FILE" \
  -p shorturl-db \
  -f "$DB_COMPOSE" \
  up -d

echo "===== 4. MariaDB 준비 대기 ====="

DB_CONTAINER="url-shortener-db"
DB_READY=false

for i in {1..60}; do
  STATUS=$(docker inspect \
    --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}' \
    "$DB_CONTAINER" 2>/dev/null || true)

  if [ "$STATUS" = "healthy" ]; then
    DB_READY=true
    break
  fi

  echo "MariaDB 준비 중... ($i/60) 상태: $STATUS"
  sleep 2
done

if [ "$DB_READY" != true ]; then
  echo "MariaDB 준비 시간 초과. Tomcat 실행을 중단합니다."
  exit 1
fi

echo "===== 5. Tomcat 실행 ====="

docker compose \
  --env-file "$ENV_FILE" \
  -p shorturl-was \
  -f "$WAS_COMPOSE" \
  up -d

echo "===== 모든 서비스 실행 완료 ====="
docker ps
