#!/bin/bash

# Christmas Buddy - App Bundle Builder
# 이 스크립트는 .app 번들을 생성하고 배포 가능한 형태로 만듭니다

set -e

APP_NAME="ChristmasBuddy"
BUILD_DIR=".build/release"
APP_BUNDLE="$APP_NAME.app"
CONTENTS="$APP_BUNDLE/Contents"
MACOS="$CONTENTS/MacOS"
RESOURCES="$CONTENTS/Resources"

echo "🎄 Christmas Buddy - App Builder"
echo "================================="

# 1. Release 모드로 빌드
echo "📦 Step 1: Building in release mode..."
swift build -c release

# 2. 기존 .app 번들 삭제
if [ -d "$APP_BUNDLE" ]; then
    echo "🗑️  Removing existing app bundle..."
    rm -rf "$APP_BUNDLE"
fi

# 3. .app 번들 구조 생성
echo "📁 Step 2: Creating app bundle structure..."
mkdir -p "$MACOS"
mkdir -p "$RESOURCES"

# 4. 실행파일 복사
echo "📋 Step 3: Copying executable..."
cp "$BUILD_DIR/$APP_NAME" "$MACOS/"
chmod +x "$MACOS/$APP_NAME"

# 5. Info.plist 복사
echo "📄 Step 4: Copying Info.plist..."
cp "ChristmasBuddy/Supporting/Info.plist" "$CONTENTS/"

# 6. 리소스 번들 복사
echo "🎨 Step 5: Copying resources..."
if [ -d "$BUILD_DIR/ChristmasBuddy_ChristmasBuddy.bundle" ]; then
    cp -R "$BUILD_DIR/ChristmasBuddy_ChristmasBuddy.bundle" "$RESOURCES/"
fi

# 7. 아이콘 설정 (있는 경우)
if [ -f "AppIcon.icns" ]; then
    echo "🎨 Step 6: Adding app icon..."
    cp "AppIcon.icns" "$RESOURCES/"
fi

# 8. 권한 설정
echo "🔐 Step 7: Setting permissions..."
chmod -R 755 "$APP_BUNDLE"

# 완료
echo ""
echo "✅ App bundle created successfully!"
echo "📦 Location: $(pwd)/$APP_BUNDLE"
echo ""
echo "🚀 Next steps:"
echo "   1. Test: open $APP_BUNDLE"
echo "   2. Create DMG: ./create_dmg.sh"
echo ""
