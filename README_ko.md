# 🎄 Christmas Buddy

<p align="center">
  <img src="https://img.shields.io/badge/platform-macOS-blue?style=flat-square" alt="Platform">
  <img src="https://img.shields.io/badge/macOS-13.0+-green?style=flat-square" alt="macOS Version">
  <img src="https://img.shields.io/badge/Swift-5.9-orange?style=flat-square" alt="Swift">
  <img src="https://img.shields.io/badge/Built%20with-Claude%20Code-blueviolet?style=flat-square" alt="Built with Claude Code">
</p>

<p align="center">
  <strong>🌐 Language / 언어 / 言語</strong><br>
  <a href="README.md">English</a> • <a href="#korean">한국어</a> • <a href="README_ja.md">日本語</a>
</p>

<p align="center">
  <a href="https://chattymin.github.io/ChristmasBuddy/">🌐 웹사이트</a> •
  <a href="https://github.com/chattymin/ChristmasBuddy/releases/latest">⬇️ 다운로드</a>
</p>

---

<a name="korean"></a>

## ✨ 소개

**Christmas Buddy**는 여러분의 Mac 데스크탑에 크리스마스 분위기를 선사하는 귀여운 데스크탑 동반자 앱입니다! 사랑스러운 캐릭터가 데스크탑 위에 살면서, 시간대별 메시지를 전달하고 흩어진 선물 상자를 수집합니다.

> 🤖 **Claude Code로 100% 바이브 코딩**
>
> 이 프로젝트는 Anthropic의 공식 CLI인 [Claude Code](https://claude.ai/download)와의 바이브 코딩을 통해 전체가 만들어졌습니다. 컨셉부터 구현까지, 모든 코드가 AI와의 자연스러운 대화를 통해 생성되었습니다.

## 🎬 미리보기

<p align="center">
  <strong>⛄ 눈사람</strong> • <strong>🎅 산타</strong> • <strong>🦌 루돌프</strong>
</p>

## 🎁 기능

| 기능 | 설명 |
|------|------|
| 💬 **시간대별 메시지** | 아침, 점심, 오후, 저녁, 밤 시간대에 맞는 귀여운 메시지를 받아보세요 |
| 🎁 **선물 상자 수집** | 화면에 선물 상자를 퍼뜨리고 캐릭터가 수집하는 것을 지켜보세요 |
| 💃 **아이들 애니메이션** | 캐릭터가 살아있는 것처럼 움직여요 |
| 😵‍💫 **어지러움 반응** | 캐릭터를 너무 오래 드래그하면 어지러워해요! |
| 🔋 **배터리 알림** | 배터리가 부족하면 알려드려요 |
| ❄️ **메뉴바 애니메이션** | 메뉴바에서 눈 내리는 크리스마스 트리를 볼 수 있어요 |
| 🎭 **다양한 캐릭터** | 눈사람, 산타, 루돌프 중에서 선택하세요 |
| 💭 **랜덤 인사** | 캐릭터가 15-30분마다 랜덤하게 인사해요 |
| 🌨️ **눈 내리기 효과** | 모든 모니터에 아름다운 눈이 내려요 |

## 📥 다운로드 및 설치

### 다운로드
👉 **[최신 버전 다운로드](https://github.com/chattymin/ChristmasBuddy/releases/latest)**

### 설치 방법
1. 위 링크에서 DMG 파일을 다운로드하세요
2. DMG를 열고 앱을 Applications 폴더로 드래그하세요
3. DMG 안의 **Install.command**를 더블클릭하세요 (보안 속성 자동 제거)
   ```bash
   ```
4. 처음 실행 시 `시스템 설정 > 개인정보 보호 및 보안`에서 앱 실행을 허용하세요
5. 메뉴바의 🎄 아이콘으로 캐릭터 변경 및 설정을 조절하세요

## 💻 시스템 요구사항

- **macOS 13.0 (Ventura)** 이상
- Apple Silicon & Intel 지원

## 🛠️ 소스에서 빌드하기

```bash
# 레포지토리 클론
git clone https://github.com/chattymin/ChristmasBuddy.git
cd ChristmasBuddy

# 앱 빌드
./build_app.sh

# 앱 실행
open ChristmasBuddy.app

# DMG 생성 (배포용)
./create_dmg.sh
```

## 📁 프로젝트 구조

```
ChristmasBuddy/
├── Sources/
│   ├── App/                  # 앱 진입점
│   ├── Core/                 # 코어 컴포넌트
│   ├── Features/             # 기능 모듈
│   │   ├── InfoDisplay/      # 정보 표시 시스템
│   │   ├── Message/          # 메시지 시스템
│   │   └── Box/              # 선물 상자 시스템
│   ├── Models/               # 데이터 모델
│   └── Resources/            # 리소스 (SVG 캐릭터)
└── Package.swift
```

## 🤖 바이브 코딩이란?

이 프로젝트는 **바이브 코딩**의 쇼케이스입니다 - 원하는 것을 자연어로 설명하면 AI가 코드를 생성하는 새로운 개발 패러다임입니다.

이 앱의 모든 기능은 Claude Code에 원하는 기능을 설명하는 것만으로 만들어졌습니다:
- "돌아다니는 눈사람 캐릭터를 추가해줘"
- "캐릭터가 선물 상자를 수집하게 해줘"
- "시간대별 인사 메시지를 추가해줘"
- "메뉴바에 눈 내리는 트리 애니메이션 아이콘을 만들어줘"

직접 코딩은 필요 없어요 - 그냥 바이브만 있으면 돼요! ✨

## 📄 라이선스

MIT License - 자세한 내용은 [LICENSE](LICENSE)를 참조하세요.

## 🙏 크레딧

- Anthropic의 [Claude Code](https://claude.ai/download)로 100% 제작
- 크리스마스를 위해 ❤️를 담아 만들었습니다

---

<p align="center">
  🎄 메리 크리스마스! 🎄
</p>
