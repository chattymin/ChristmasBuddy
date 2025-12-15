#!/bin/bash

# Christmas Desktop Buddy - DMG Creator
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

# README 추가
cat > dmg_temp/README.txt << 'EOF'
🎄 Christmas Desktop Buddy v1.1.0

== 설치 방법 ==
1. ChristmasDesktopBuddy.app을 Applications 폴더로 드래그하세요
2. Applications 폴더에서 앱을 실행하세요
3. 메뉴바의 🎄 아이콘을 클릭하여 설정하세요

== 사용 방법 ==
- 클릭: 정보 표시
- 드래그: 위치 이동
- 메뉴바 🎄: 캐릭터 변경 및 설정

== 기능 ==
✨ 3가지 캐릭터: 눈사람, 산타, 루돌프
📊 배터리 및 시간 정보 표시
💬 시간대별 랜덤 메시지
🖱️ 드래그 이동 가능

GitHub: https://github.com/yourusername/christmas-desktop-buddy
License: MIT

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
