#!/bin/bash

# Christmas Buddy - DMG Creator
# 배포용 DMG 이미지를 생성합니다

set -e

APP_NAME="ChristmasDesktopBuddy"
APP_BUNDLE="$APP_NAME.app"
DMG_NAME="ChristmasDesktopBuddy-v1.1.0"
VOLUME_NAME="Christmas Desktop Buddy"

echo "🎄 Creating distributable DMG..."
echo "================================"

# .app 번들 확인
if [ ! -d "$APP_BUNDLE" ]; then
    echo "❌ Error: $APP_BUNDLE not found!"
    echo "Please run ./build_app.sh first"
    exit 1
fi

# 기존 DMG 삭제
rm -f "${DMG_NAME}.dmg"
rm -rf dmg_temp

# 임시 폴더 생성
echo "📁 Creating temporary folder..."
mkdir -p dmg_temp
cp -R "$APP_BUNDLE" dmg_temp/

# Applications 폴더 심볼릭 링크 생성
echo "🔗 Creating Applications symlink..."
ln -s /Applications dmg_temp/Applications

# README 추가 (중요한 설치 안내)
cat > "dmg_temp/⚠️ 설치방법 (먼저 읽어주세요).txt" << 'EOF'
🎄 Christmas Desktop Buddy v1.1.0 설치 방법
=====================================

🍺 Homebrew로 설치하기 (권장)
-------------------------------------
터미널에서 아래 명령어를 실행하세요:

brew tap chattymin/christmasbuddy && brew install --cask christmas-buddy

✅ Homebrew로 설치하면 보안 경고 없이
   바로 실행할 수 있습니다!

=====================================

📦 DMG로 직접 설치하기
-------------------------------------
1️⃣ ChristmasDesktopBuddy.app을 Applications 폴더로 드래그

2️⃣ Applications 폴더에서 앱을 찾아서:
   👉 앱을 "우클릭" (또는 Control + 클릭)
   👉 "열기" 선택
   👉 경고창에서 "열기" 버튼 클릭

⚠️ 일반 더블클릭으로는 열리지 않습니다!
   반드시 우클릭 → 열기로 실행해주세요.

=====================================
GitHub: https://github.com/chattymin/ChristmasBuddy
Merry Christmas! 🎅
EOF

# DMG 생성
echo "💿 Creating DMG..."
hdiutil create -volname "$VOLUME_NAME" \
    -srcfolder dmg_temp \
    -ov -format UDZO \
    "${DMG_NAME}.dmg"

# 임시 폴더 삭제
echo "🧹 Cleaning up..."
rm -rf dmg_temp

echo ""
echo "✅ DMG created successfully!"
echo "📦 File: $(pwd)/${DMG_NAME}.dmg"
echo ""
echo "🚀 You can now distribute this DMG file!"
echo ""
