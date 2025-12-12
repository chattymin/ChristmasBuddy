# 빠른 시작 가이드 🚀

## 앱 테스트하기

```bash
# 앱 실행 (개발 모드)
swift run

# 또는 빌드된 .app 실행
open ChristmasDesktopBuddy.app
```

## 배포 준비 체크리스트

### 1. 로컬에서 테스트

```bash
# .app 번들 생성
./build_app.sh

# 앱 실행해서 테스트
open ChristmasDesktopBuddy.app

# 문제없으면 DMG 생성
./create_dmg.sh
```

### 2. GitHub에 푸시

```bash
# 모든 변경사항 커밋
git add .
git commit -m "준비 완료: v1.0 릴리즈"
git push origin main
```

### 3. Release 생성

#### 방법 A: GitHub Actions 사용 (자동)

```bash
# 태그 생성 및 푸시
git tag v1.0
git push origin v1.0

# GitHub Actions가 자동으로:
# 1. 앱 빌드
# 2. DMG 생성
# 3. Release 생성
# 4. DMG 업로드
```

몇 분 후 https://github.com/yourusername/christmas-desktop-buddy/releases 에서 확인!

#### 방법 B: 수동 업로드

1. 로컬에서 DMG 생성:
   ```bash
   ./build_app.sh
   ./create_dmg.sh
   ```

2. GitHub Release 생성:
   - https://github.com/yourusername/christmas-desktop-buddy/releases/new
   - Tag: v1.0
   - Title: Christmas Desktop Buddy v1.0
   - DMG 파일 업로드

### 4. 공유하기

Release URL을 공유:
```
https://github.com/yourusername/christmas-desktop-buddy/releases/latest
```

## 일반적인 문제

### "개발자를 확인할 수 없습니다" 경고

**이유**: 앱이 Apple에 의해 공증되지 않았습니다.

**해결방법**:
1. 시스템 설정 → 개인 정보 보호 및 보안
2. "확인 없이 열기" 클릭

**장기 해결책**: Apple Developer Program 가입 후 코드 서명 ($99/년)

### DMG 크기 줄이기

현재: ~116KB (매우 작음!)

더 줄이려면:
```bash
# Strip symbols (디버그 정보 제거)
swift build -c release -Xswiftc -Osize
```

### 앱이 실행되지 않음

```bash
# 터미널에서 직접 실행하여 에러 확인
.build/release/ChristmasDesktopBuddy

# 또는 .app 내 실행파일
./ChristmasDesktopBuddy.app/Contents/MacOS/ChristmasDesktopBuddy
```

## 버전 업데이트

### 새 버전 릴리즈 (예: v1.1)

1. 코드 수정

2. Info.plist 버전 업데이트:
   ```xml
   <key>CFBundleShortVersionString</key>
   <string>1.1</string>
   ```

3. create_dmg.sh의 DMG_NAME 변경:
   ```bash
   DMG_NAME="ChristmasDesktopBuddy-v1.1"
   ```

4. 빌드 및 릴리즈:
   ```bash
   git add .
   git commit -m "Release v1.1"
   git tag v1.1
   git push origin main
   git push origin v1.1
   ```

## 통계 확인

### GitHub Release 다운로드 수

```bash
# GitHub CLI 설치 후
gh release view v1.0
```

### 사용자 피드백

- GitHub Issues 활성화
- Discussions 활성화
- Twitter/X 멘션 모니터링

## 마케팅 아이디어

1. **Reddit 게시**
   - /r/macapps
   - /r/apple
   - /r/SideProject

2. **Product Hunt 런칭**
   - https://www.producthunt.com/posts/new

3. **Hacker News**
   - Show HN: Christmas Desktop Buddy - 맥OS 데스크탑 캐릭터

4. **Twitter/X**
   - 스크린샷과 함께 트윗
   - #macOS #app #Christmas 해시태그

5. **개인 블로그**
   - 개발 과정 회고
   - 기술 스택 설명

## 다음 단계

- [ ] 스크린샷 촬영 및 README에 추가
- [ ] GitHub Repository 설명 업데이트
- [ ] Topics 추가: macos, swift, desktop-app, christmas
- [ ] LICENSE 파일 추가
- [ ] CHANGELOG.md 작성
- [ ] 사용자 가이드 영상 제작 (선택)

---

**Good luck with your launch! 🎄**
