#!/bin/bash

# Christmas Buddy - DMG Creator
# 배포용 DMG 이미지를 생성합니다

set -e

APP_NAME="ChristmasBuddy"
APP_BUNDLE="$APP_NAME.app"
DMG_NAME="ChristmasBuddy-v1.1.0"
VOLUME_NAME="Christmas Buddy"

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

# Install.command 생성 (quarantine 속성 제거)
echo "📝 Creating install script..."
cat > dmg_temp/Install.command << 'INSTALLEOF'
#!/bin/bash
# Christmas Buddy Installer
# 이 스크립트는 앱의 quarantine 속성을 제거합니다

APP_PATH="/Applications/ChristmasBuddy.app"

echo "🎄 Christmas Buddy 설치 중..."
echo ""

# quarantine 속성 제거
if [ -d "$APP_PATH" ]; then
    echo "🔓 보안 속성 제거 중..."
    xattr -cr "$APP_PATH"
    echo "✅ 완료!"
    echo ""
    echo "🚀 앱을 실행합니다..."
    open "$APP_PATH"
else
    echo "❌ 앱을 먼저 Applications 폴더로 드래그해주세요!"
    echo ""
    echo "1. ChristmasBuddy.app을 Applications 폴더로 드래그"
    echo "2. 이 스크립트를 다시 실행"
fi
INSTALLEOF
chmod +x dmg_temp/Install.command

# README 추가
cat > dmg_temp/README.txt << 'EOF'
🎄 Christmas Buddy v1.1.0

== 설치 방법 ==
1. ChristmasBuddy.app을 Applications 폴더로 드래그하세요
2. Install.command를 더블클릭하세요 (보안 속성 제거)
3. 앱이 자동으로 실행됩니다!

== 사용 방법 ==
- 클릭: 정보 표시
- 드래그: 위치 이동
- 메뉴바 🎄: 캐릭터 변경 및 설정

== 기능 ==
✨ 3가지 캐릭터: 눈사람, 산타, 루돌프
📊 배터리 및 시간 정보 표시
💬 시간대별 랜덤 메시지
💭 랜덤 인사 (15-30분마다)
🌨️ 눈 내리기 효과 (모든 모니터)
🖱️ 드래그 이동 가능

GitHub: https://github.com/chattymin/ChristmasBuddy
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
