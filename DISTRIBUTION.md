# 배포 가이드 📦

Christmas Desktop Buddy를 다른 사람들에게 배포하는 방법입니다.

## 빌드된 파일

- **ChristmasDesktopBuddy.app** - macOS 앱 번들 (직접 실행 가능)
- **ChristmasDesktopBuddy-v1.0.dmg** - 배포용 디스크 이미지 (권장)

## 배포 방법

### 1. GitHub Release 배포 (권장)

```bash
# 1. GitHub에 코드 푸시
git add .
git commit -m "Release v1.0"
git tag v1.0
git push origin main
git push origin v1.0

# 2. GitHub에서 Release 생성
# - https://github.com/yourusername/christmas-desktop-buddy/releases/new
# - Tag: v1.0
# - Title: Christmas Desktop Buddy v1.0
# - DMG 파일 업로드: ChristmasDesktopBuddy-v1.0.dmg
```

#### Release 노트 템플릿

```markdown
# Christmas Desktop Buddy v1.0 🎄

맥OS 데스크탑 위에 떠다니는 귀여운 크리스마스 캐릭터!

## 다운로드

**[ChristmasDesktopBuddy-v1.0.dmg](링크)** (116KB)

## 설치 방법

1. DMG 파일을 다운로드합니다
2. DMG를 열고 `ChristmasDesktopBuddy.app`을 `Applications` 폴더로 드래그합니다
3. Applications 폴더에서 앱을 실행합니다
4. 첫 실행 시 "신뢰할 수 없는 개발자" 경고가 나타나면:
   - 시스템 설정 → 개인 정보 보호 및 보안 → "확인 없이 열기" 클릭

## 기능 ✨

- 🎨 3가지 캐릭터: 눈사람 ⛄, 산타 🎅, 루돌프 🦌
- 📊 배터리 및 시간 정보 표시
- 💬 시간대별 랜덤 메시지
- 🖱️ 드래그로 위치 이동
- 🎄 메뉴바 통합

## 시스템 요구사항

- macOS 13.0 (Ventura) 이상
- Apple Silicon 또는 Intel 프로세서

## 사용 방법

- **클릭**: 정보 표시
- **드래그**: 위치 이동
- **메뉴바 🎄**: 캐릭터 변경 및 설정

## 스크린샷

[스크린샷 추가 예정]

## 라이선스

MIT License

---

메리 크리스마스! 🎅
```

### 2. 직접 배포

DMG 파일을 다음과 같은 방법으로 배포할 수 있습니다:

- Google Drive / Dropbox 링크 공유
- 개인 웹사이트에 호스팅
- 이메일로 직접 전송

### 3. 다시 빌드하기

새 버전을 빌드할 때:

```bash
# 1. 코드 수정

# 2. 버전 업데이트
# ChristmasDesktopBuddy/Supporting/Info.plist에서:
# CFBundleShortVersionString을 1.1로 변경

# 3. 재빌드
./build_app.sh

# 4. 새 DMG 생성
# create_dmg.sh에서 버전 번호 변경 후:
./create_dmg.sh
```

## 코드 서명 (선택사항)

앱을 Apple Developer Program에 등록된 인증서로 서명하면 사용자가 경고 없이 실행할 수 있습니다:

```bash
# Apple Developer 계정 필요 ($99/년)
codesign --force --deep --sign "Developer ID Application: Your Name" ChristmasDesktopBuddy.app
```

## Notarization (선택사항)

macOS Gatekeeper 경고를 제거하려면 Apple에 앱을 공증받아야 합니다:

```bash
# 1. 앱 서명
codesign --force --deep --sign "Developer ID Application: Your Name" ChristmasDesktopBuddy.app

# 2. ZIP으로 압축
ditto -c -k --keepParent ChristmasDesktopBuddy.app ChristmasDesktopBuddy.zip

# 3. Notarization 제출
xcrun notarytool submit ChristmasDesktopBuddy.zip \
  --apple-id "your-apple-id@email.com" \
  --team-id "YOUR_TEAM_ID" \
  --password "app-specific-password"

# 4. Staple
xcrun stapler staple ChristmasDesktopBuddy.app
```

## 자동 업데이트 (추후 계획)

Sparkle 프레임워크를 사용하여 자동 업데이트 기능을 추가할 수 있습니다.

## 문제 해결

### "악성 소프트웨어 확인 불가" 경고

사용자에게 다음 방법 안내:
1. 시스템 설정 → 개인 정보 보호 및 보안
2. "확인 없이 열기" 버튼 클릭

### 앱이 실행되지 않음

- macOS 버전 확인 (13.0 이상 필요)
- 터미널에서 실행하여 에러 확인:
  ```bash
  /Applications/ChristmasDesktopBuddy.app/Contents/MacOS/ChristmasDesktopBuddy
  ```

## 홍보 아이디어

- Reddit (/r/macapps, /r/apple)
- Product Hunt
- Hacker News (Show HN)
- Twitter/X
- 개인 블로그

---

**Happy Releasing! 🎉**
