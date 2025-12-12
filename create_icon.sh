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

# Python을 사용하여 도트 아트 아이콘 생성
cat > generate_icon.py << 'EOF'
#!/usr/bin/env python3
from PIL import Image, ImageDraw
import sys

def create_pixel_art_icon(size, filename):
    """도트 아트 스타일의 크리스마스 트리 아이콘 생성"""
    # 이미지 생성
    img = Image.new('RGBA', (size, size), (255, 255, 255, 0))
    draw = ImageDraw.Draw(img)

    # 픽셀 크기 계산 (16x16 그리드 기준)
    pixel_size = size // 16

    def draw_pixel(x, y, color):
        """단일 픽셀 그리기"""
        x1 = x * pixel_size
        y1 = y * pixel_size
        x2 = x1 + pixel_size
        y2 = y1 + pixel_size
        draw.rectangle([x1, y1, x2, y2], fill=color)

    # 색상 정의
    green = (34, 139, 34, 255)      # 트리 녹색
    dark_green = (0, 100, 0, 255)   # 트리 진한 녹색
    brown = (139, 69, 19, 255)      # 나무 줄기
    red = (220, 20, 60, 255)        # 장식 빨강
    yellow = (255, 215, 0, 255)     # 별

    # 배경 (둥근 모서리)
    bg_color = (41, 128, 185, 255)  # 파란 배경
    for y in range(16):
        for x in range(16):
            # 원형 마스크
            dx = x - 7.5
            dy = y - 7.5
            if dx*dx + dy*dy <= 64:
                draw_pixel(x, y, bg_color)

    # 별 (꼭대기)
    draw_pixel(7, 1, yellow)
    draw_pixel(8, 1, yellow)
    draw_pixel(7, 2, yellow)
    draw_pixel(8, 2, yellow)

    # 트리 상단부
    draw_pixel(7, 3, green)
    draw_pixel(8, 3, green)

    draw_pixel(6, 4, green)
    draw_pixel(7, 4, dark_green)
    draw_pixel(8, 4, green)
    draw_pixel(9, 4, green)

    draw_pixel(6, 5, green)
    draw_pixel(7, 5, green)
    draw_pixel(8, 5, dark_green)
    draw_pixel(9, 5, green)

    # 트리 중간부
    draw_pixel(5, 6, green)
    draw_pixel(6, 6, dark_green)
    draw_pixel(7, 6, green)
    draw_pixel(8, 6, green)
    draw_pixel(9, 6, green)
    draw_pixel(10, 6, green)

    draw_pixel(5, 7, green)
    draw_pixel(6, 7, green)
    draw_pixel(7, 7, red)  # 장식
    draw_pixel(8, 7, dark_green)
    draw_pixel(9, 7, green)
    draw_pixel(10, 7, green)

    draw_pixel(4, 8, green)
    draw_pixel(5, 8, green)
    draw_pixel(6, 8, dark_green)
    draw_pixel(7, 8, green)
    draw_pixel(8, 8, green)
    draw_pixel(9, 8, red)  # 장식
    draw_pixel(10, 8, green)
    draw_pixel(11, 8, green)

    # 트리 하단부
    draw_pixel(4, 9, green)
    draw_pixel(5, 9, dark_green)
    draw_pixel(6, 9, green)
    draw_pixel(7, 9, green)
    draw_pixel(8, 9, green)
    draw_pixel(9, 9, green)
    draw_pixel(10, 9, dark_green)
    draw_pixel(11, 9, green)

    draw_pixel(3, 10, green)
    draw_pixel(4, 10, green)
    draw_pixel(5, 10, green)
    draw_pixel(6, 10, red)  # 장식
    draw_pixel(7, 10, dark_green)
    draw_pixel(8, 10, green)
    draw_pixel(9, 10, green)
    draw_pixel(10, 10, green)
    draw_pixel(11, 10, green)
    draw_pixel(12, 10, green)

    draw_pixel(3, 11, green)
    draw_pixel(4, 11, dark_green)
    draw_pixel(5, 11, green)
    draw_pixel(6, 11, green)
    draw_pixel(7, 11, green)
    draw_pixel(8, 11, green)
    draw_pixel(9, 11, dark_green)
    draw_pixel(10, 11, green)
    draw_pixel(11, 11, green)
    draw_pixel(12, 11, green)

    # 나무 줄기
    draw_pixel(6, 12, brown)
    draw_pixel(7, 12, brown)
    draw_pixel(8, 12, brown)
    draw_pixel(9, 12, brown)

    draw_pixel(6, 13, brown)
    draw_pixel(7, 13, brown)
    draw_pixel(8, 13, brown)
    draw_pixel(9, 13, brown)

    img.save(filename, 'PNG')
    print(f"✓ Created {filename}")

def create_icon(size, filename):
    create_pixel_art_icon(size, filename)

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
