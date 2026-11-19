
# Git & GitHub 팀 작업 시작 가이드

이 문서는 Git을 처음 사용하는 팀원을 위한 안내서입니다.

Git 명령어를 모두 외울 필요는 없습니다. VS Code와 Git Bash를 이용해 설치부터 프로젝트 내려받기, 브랜치 생성, 커밋, 푸시, 풀 리퀘스트까지 진행합니다.

## 1. GitHub 계정 만들기

1. [GitHub](https://github.com) 접속
2. Sign up(가입) 클릭
3. 계정 생성 및 이메일 인증

계정 생성 후 팀 관리자에게 GitHub 사용자 이름을 전달합니다.

팀 프로젝트 저장소에 접근하려면 관리자가 해당 GitHub 계정을 공동 작업자(Collaborator)로 초대해야 합니다.

초대 이메일을 받으면 수락합니다.

## 2. Git 설치

1. [Git 설치 페이지](https://git-scm.com/install/windows) 접속
2. Windows용 Git 다운로드 및 설치
3. 설치 옵션은 기본값으로 진행

설치 확인:

```bash
git --version
```

버전 정보가 표시되면 설치 완료입니다.

## 3. VS Code 설치

1. [VS Code 다운로드 페이지](https://code.visualstudio.com/download) 접속
2. Windows용 VS Code 설치
3. VS Code 실행

### 한국어 설정

1. 확장(Extensions) 메뉴 열기 (`Ctrl + Shift + X`)
2. Korean Language Pack for Visual Studio Code 검색
3. 설치 후 VS Code 재시작

### Git Bash 설정

VS Code에서 기본 터미널을 Git Bash로 변경합니다.

1. `Ctrl + Shift + P`
2. `터미널: 기본 프로필 선택` 검색
3. Git Bash 선택
4. `Ctrl + \`` 로 터미널 열기

이후 VS Code에서 사용하는 터미널은 Git Bash로 통일합니다.

## 4. Git 사용자 정보 확인

Git은 커밋 작성자를 표시하기 위해 이름과 이메일 정보가 필요합니다.

먼저 현재 설정을 확인합니다.

```bash
git config user.name
git config user.email
```

값이 표시되면 추가 설정할 필요가 없습니다.

값이 없다면 다음 명령어로 설정합니다.

```bash
git config --global user.name "본인 이름"
git config --global user.email "GitHub 이메일"
```

## 5. 팀 프로젝트 내려받기 (Clone)

Clone은 GitHub에 있는 팀 프로젝트를 내 PC로 내려받는 작업입니다.

VS Code 터미널에서 다음 명령어를 실행합니다.

```bash
git clone https://github.com/hynwkm/url-shortener.git
```

GitHub 인증 요청이 나타나면 본인의 GitHub 계정으로 로그인합니다.

Clone이 완료되면 프로젝트 폴더로 이동합니다.

```bash
cd url-shortener
```

VS Code에서 프로젝트 폴더를 엽니다.

```bash
code .
```

## 6. 브랜치 생성 및 이동

브랜치(Branch)는 각자 독립적으로 작업하기 위한 공간입니다.

팀원들은 `main`에서 직접 작업하지 않고 개인 브랜치를 만들어 작업합니다.

### 브랜치 확인

```bash
git branch
```

현재 사용 중인 브랜치에는 `*` 표시가 나타납니다.

### main으로 이동

```bash
git checkout main
```

### 최신 main 가져오기

```bash
git pull
```

### 작업 브랜치 생성 및 이동

본인의 GitHub 사용자 이름을 앞에 붙여 브랜치를 생성합니다.

```bash
git checkout -b username/작업이름
```

예시:

```bash
git checkout -b hynwkm/docker-add-feature
```

`checkout -b`는 브랜치를 새로 만들면서 동시에 해당 브랜치로 이동합니다.

### 기존 브랜치로 이동

```bash
git checkout username/작업이름
```

예시:

```bash
git checkout hynwkm/docker-add-feature
```

`checkout`은 이미 존재하는 브랜치로 이동합니다.

## 7. 파일 수정 및 커밋

작업 브랜치에서 필요한 파일을 수정합니다.

예를 들어 다음과 같은 작업을 진행할 수 있습니다.

- `Dockerfile` 작성
- `compose.yml` 설정
- Terraform 리소스 구성
- AWS 인프라 설정 변경

### 변경 사항 등록

```bash
git add .
```

수정한 파일들을 커밋 대상으로 등록합니다.

### 커밋

```bash
git commit -m "작업 내용"
```

예시:

```bash
git commit -m "Docker Compose 설정 추가"
```

커밋은 작업 내용을 내 PC의 Git 저장소에 기록하는 단계입니다.

커밋 메시지는 작업 내용을 알 수 있도록 간결하게 작성합니다.

예시:

```bash
git commit -m "Dockerfile 추가"
git commit -m "Terraform 기본 설정 추가"
git commit -m "VPC 및 서브넷 구성"
git commit -m "보안 그룹 인바운드 규칙 수정"
git commit -m "변수 및 출력값 정의"
```

## 8. GitHub에 작업 업로드 (Push)

Push는 내 PC에 있는 커밋을 GitHub 저장소에 업로드하는 작업입니다.

```bash
git push
```

작업 브랜치에서 실행해야 합니다.

## 9. 최신 작업 가져오기 (Pull)

다른 팀원이 작업한 내용을 내 PC에 반영하려면 Pull을 사용합니다.

먼저 업데이트할 브랜치로 이동합니다.

```bash
git checkout main
```

최신 main 가져오기:

```bash
git pull
```

### 개인 작업 브랜치에 최신 main 반영하기

다른 팀원이 `main`에 병합한 변경 사항을 내 작업 브랜치에도 반영하려면 다음 순서로 진행합니다.

```bash
git checkout main
git pull
git checkout username/작업이름
git merge main
```

이렇게 하면 최신 `main`의 변경 사항이 개인 작업 브랜치에 반영됩니다.

## 10. 작업 브랜치를 main에 병합하기 (Pull Request)

작업이 완료되면 개인 작업 브랜치의 변경 사항을 팀의 `main` 브랜치에 반영합니다.

이때 내 PC에서 직접 병합하지 않고, GitHub의 풀 리퀘스트(Pull Request, PR)를 사용합니다.

풀 리퀘스트는 개인 작업 브랜치의 변경 사항을 `main`에 반영해 달라고 요청하는 기능입니다. 팀원이 변경 내용을 검토한 후 병합할 수 있습니다.

### 10.1 작업 브랜치 업로드

먼저 작업 브랜치의 최신 커밋을 GitHub에 업로드합니다.

```bash
git checkout username/작업이름
git push
```

### 10.2 GitHub에서 풀 리퀘스트 생성

1. GitHub에서 팀 프로젝트 저장소에 접속합니다.
2. 상단의 Pull requests(풀 리퀘스트) 탭을 선택합니다.
3. New pull request(새 풀 리퀘스트)를 클릭합니다.
4. 다음과 같이 브랜치를 설정합니다.
   - **Base:** `main` (변경 사항을 반영할 대상 브랜치)
   - **Compare:** `username/작업이름` (내가 작업한 브랜치)
5. 변경된 파일과 내용을 확인합니다.
6. Create pull request(풀 리퀘스트 생성)를 클릭합니다.

### 10.3 풀 리퀘스트 작성

풀 리퀘스트 제목과 설명을 작성합니다.

제목 예시:

```text
Docker Compose 설정 추가
```

설명 예시:

```text
- Dockerfile 추가
- Docker Compose 설정 추가
- 컨테이너 실행 환경 구성
```

작성 후 Create pull request를 클릭합니다.

### 10.4 코드 검토 및 병합

풀 리퀘스트가 생성되면 팀원이 변경 내용을 검토합니다.

- 변경된 파일과 작업 내용 확인
- 수정이 필요한 경우 작성자에게 변경 요청(Request changes)
- 문제가 없으면 승인(Approve)

검토가 완료되면 Merge pull request(병합)를 클릭하고 최종 확인을 진행합니다.

이제 개인 작업 브랜치의 변경 사항이 GitHub 원격 저장소의 `main`에 반영됩니다.

### 10.5 병합 완료 후 최신 main 가져오기

풀 리퀘스트가 병합되면 GitHub의 `main`이 업데이트됩니다.

다음 작업을 시작하기 전에 내 PC의 `main`도 최신 상태로 업데이트합니다.

```bash
git checkout main
git pull
```

이제 내 PC의 `main`에도 병합된 변경 사항이 반영됩니다.

---

## Git 명령어 요약

| 명령어 | 기능 |
|---|---|
| `git --version` | Git 설치 확인 |
| `git config user.name` | 사용자 이름 확인 |
| `git config user.email` | 사용자 이메일 확인 |
| `git clone URL` | 원격 저장소 내려받기 |
| `git branch` | 브랜치 목록 확인 |
| `git checkout main` | main 브랜치로 이동 |
| `git checkout -b 이름` | 브랜치 생성 및 이동 |
| `git checkout 이름` | 기존 브랜치로 이동 |
| `git status` | 변경 사항 확인 |
| `git add .` | 변경 파일을 커밋 대상으로 등록 |
| `git commit -m "메시지"` | 작업 내용 기록 |
| `git push` | GitHub에 작업 업로드 |
| `git pull` | 원격 저장소의 변경 사항 가져오기 |
| `git merge main` | main의 변경 사항을 현재 브랜치에 병합 |

## 팀 작업 기본 규칙

- `main`에서 직접 작업하지 않습니다.
- 모든 작업은 개인 브랜치에서 진행합니다.
- 브랜치 이름은 `GitHub사용자이름/작업내용` 형식으로 작성합니다.
- 작업 내용을 커밋하고 GitHub에 업로드합니다.
- 작업 완료 후 풀 리퀘스트를 생성합니다.
- 팀원 검토 후 GitHub에서 병합합니다.
- 병합 완료 후 다음 작업을 시작하기 전에 로컬 `main`을 업데이트합니다.
- AWS 액세스 키, 비밀번호, `.env` 파일 등 민감한 정보는 커밋하지 않습니다.
