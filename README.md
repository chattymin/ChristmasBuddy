# Christmas Desktop Buddy 🎄

맥OS 데스크탑 위에 떠다니는 귀여운 크리스마스 캐릭터!

![Christmas Desktop Buddy](screenshot.png)

## 기능 ✨

- **떠다니는 캐릭터**: 데스크탑 위에 작은 크리스마스 캐릭터가 떠다닙니다
- **3가지 캐릭터**: 눈사람 ⛄, 산타 🎅, 루돌프 🦌
- **정보 표시**: 클릭하면 배터리 상태, 현재 시간, 랜덤 멘트 표시
- **드래그 이동**: 캐릭터를 원하는 위치로 드래그 가능
- **항상 최상위**: 다른 창 위에 항상 표시

## 다운로드 및 설치 📥

### 사용자용 (일반 사용자)

1. [Releases 페이지](https://github.com/yourusername/christmas-desktop-buddy/releases)에서 최신 DMG 파일 다운로드
2. DMG를 열고 `ChristmasDesktopBuddy.app`을 `Applications` 폴더로 드래그
3. Applications 폴더에서 앱 실행
4. 첫 실행 시 보안 경고가 나타나면:
   - **시스템 설정** → **개인 정보 보호 및 보안** → **"확인 없이 열기"** 클릭

### 개발자용 (소스코드 빌드)

```bash
# Swift Package Manager로 빌드
swift build

# 실행
swift run

# .app 번들 생성
./build_app.sh

# DMG 생성 (배포용)
./create_dmg.sh
```

## Xcode로 빌드

```bash
# Xcode 프로젝트 생성
swift package generate-xcodeproj

# Xcode에서 열기
open ChristmasDesktopBuddy.xcodeproj
```

## 기술 스택 💻

- Swift 5.9+
- SwiftUI
- AppKit (macOS)
- macOS 13.0+

## 프로젝트 구조 📁

```
ChristmasDesktopBuddy/
├── Sources/
│   ├── App/                  # 앱 진입점
│   ├── Core/                 # 코어 컴포넌트
│   ├── Features/             # 기능별 모듈
│   │   ├── InfoDisplay/      # 정보 표시 시스템
│   │   └── Message/          # 메시지 시스템
│   ├── Models/               # 데이터 모델
│   └── Resources/            # 리소스 (SVG 캐릭터)
└── Package.swift
```

## 확장 가능성 🚀

InfoProvider 프로토콜을 구현하여 새로운 정보를 쉽게 추가할 수 있습니다:

```swift
class CustomProvider: InfoProvider {
    var icon: String { "📊" }
    var title: String { "Custom Info" }
    var priority: Int { 3 }

    func getValue() async -> String {
        return "Custom Value"
    }
}
```

## Phase 2 계획 🎯

- [ ] 중력 물리 엔진 (창/Dock에 착지)
- [ ] 자동 이동 AI
- [ ] 캘린더 연동 (미팅 정보)
- [ ] 날씨 정보
- [ ] 애니메이션 추가

## 라이선스 📝

MIT License
