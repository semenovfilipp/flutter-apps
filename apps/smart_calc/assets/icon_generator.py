#!/usr/bin/env python3
from PIL import Image, ImageDraw, ImageFont
import os

size = 1024
img = Image.new('RGB', (size, size), color='#2196F3')
draw = ImageDraw.Draw(img)

try:
    font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 600)
except:
    try:
        font = ImageFont.truetype("/usr/share/fonts/TTF/DejaVuSans-Bold.ttf", 600)
    except:
        font = ImageFont.load_default()

text = "SC"
bbox = draw.textbbox((0, 0), text, font=font)
text_width = bbox[2] - bbox[0]
text_height = bbox[3] - bbox[1]

x = (size - text_width) // 2
y = (size - text_height) // 2 - 50

draw.text((x, y), text, fill='white', font=font)

icon_path = os.path.join(os.path.dirname(__file__), 'icon.png')
img.save(icon_path)
print(f"Icon saved to: {icon_path}")
