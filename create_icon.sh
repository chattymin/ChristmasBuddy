#!/bin/bash

# Christmas Desktop Buddy - Icon Creator
# 이모지를 사용하여 간단한 앱 아이콘 생성

echo "🎨 Creating app icon from emoji..."

# iconutil을 사용하려면 PNG 이미지가 필요합니다
# 여기서는 간단히 sips와 이모지 텍스트를 사용합니다

# 임시 iconset 폴더 생성
ICONSET="AppIcon.iconset"
rm -rf "$ICONSET"
mkdir -p "$ICONSET"

# Python을 사용하여 이모지 이미지 생성
cat > generate_icon.py << 'EOF'
#!/usr/bin/env python3
from PIL import Image, ImageDraw, ImageFont
import sys

def create_icon(size, filename):
    # 이미지 생성 (투명 배경)
    img = Image.new('RGBA', (size, size), (255, 255, 255, 0))
    draw = ImageDraw.Draw(img)

    # 배경 원 그리기
    margin = size // 10
    draw.ellipse([margin, margin, size-margin, size-margin],
                 fill=(220, 38, 38, 255))  # 크리스마스 레드

    # 텍스트 (이모지) 추가
    try:
        font_size = int(size * 0.6)
        # macOS 시스템 폰트 사용
        font = ImageFont.truetype("/System/Library/Fonts/Apple Color Emoji.ttc", font_size)
        text = "🎄"

        # 텍스트 위치 계산
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        x = (size - text_width) // 2 - bbox[0]
        y = (size - text_height) // 2 - bbox[1]

        draw.text((x, y), text, font=font, embedded_color=True)
    except Exception as e:
        print(f"Warning: Could not add emoji: {e}")

    img.save(filename, 'PNG')
    print(f"✓ Created {filename}")

# 필요한 모든 사이즈 생성
sizes = [
    (16, "icon_16x16.png"),
    (32, "icon_16x16@2x.png"),
    (32, "icon_32x32.png"),
    (64, "icon_32x32@2x.png"),
    (128, "icon_128x128.png"),
    (256, "icon_128x128@2x.png"),
    (256, "icon_256x256.png"),
    (512, "icon_256x256@2x.png"),
    (512, "icon_512x512.png"),
    (1024, "icon_512x512@2x.png"),
]

import os
iconset_dir = "AppIcon.iconset"
os.makedirs(iconset_dir, exist_ok=True)

for size, filename in sizes:
    create_icon(size, os.path.join(iconset_dir, filename))

print("✅ All icon sizes created!")
EOF

# Pillow가 설치되어 있는지 확인
if python3 -c "import PIL" 2>/dev/null; then
    echo "✓ Pillow found, generating icons..."
    python3 generate_icon.py

    # iconset을 icns로 변환
    echo "📦 Converting to .icns..."
    iconutil -c icns "$ICONSET" -o AppIcon.icns

    # 정리
    rm -rf "$ICONSET"
    rm generate_icon.py

    echo "✅ AppIcon.icns created successfully!"
else
    echo "⚠️  Pillow not installed. Installing..."
    echo "Run: pip3 install Pillow"
    echo ""
    echo "Or skip icon creation - the app will work without a custom icon"
    rm generate_icon.py
fi
