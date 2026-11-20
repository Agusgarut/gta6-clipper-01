#!/bin/bash
# gta6-clipper-01 — clip build, run in-session 2026-11-20
# Source: src/speed_hulk_source.mp4 (1920x1080, 128s)
# Moment: source 96.0-120.0s (hug -> stands -> leap -> Jason launched)
set -e
cd "$(dirname "$0")"
SRC=src/speed_hulk_source.mp4
FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf
mkdir -p build

# --- extract the end-card background frame (Jason mid-launch, source t=116) ---
ffmpeg -v error -ss 116 -i "$SRC" -frames:v 1 build/card_bg.png -y

# --- segment A: footage 96.0-120.0, crop x=660 w=608 -> 1080x1920, burned text ---
ffmpeg -v error -ss 96 -i "$SRC" -t 24 -vf "\
crop=608:1080:660:0,scale=1080:1920,setsar=1,\
drawtext=fontfile=$FONT:text='HE FOUND A RED HULK':fontsize=62:fontcolor=white:borderw=5:bordercolor=black:x=(w-text_w)/2:y=180:enable='between(t,0,3.5)',\
drawtext=fontfile=$FONT:text='IN GTA 6?!':fontsize=62:fontcolor=white:borderw=5:bordercolor=black:x=(w-text_w)/2:y=275:enable='between(t,0,3.5)',\
drawtext=fontfile=$FONT:text='HE JUST WANTED A HUG':fontsize=62:fontcolor=white:borderw=5:bordercolor=black:x=(w-text_w)/2:y=210:enable='between(t,4.5,9)',\
drawtext=fontfile=$FONT:text='THEN HE STOOD UP...':fontsize=62:fontcolor=white:borderw=5:bordercolor=black:x=(w-text_w)/2:y=210:enable='between(t,10.5,14.5)'" \
  -af "afade=t=out:st=23:duration=1" \
  -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -r 30 -c:a aac -b:a 160k -ar 48000 -ac 2 build/seg_a.mp4 -y

# --- segment B: pitch end-card, 6.5s, blurred/darkened launch frame ---
ffmpeg -v error -loop 1 -i build/card_bg.png -f lavfi -i anullsrc=r=48000:cl=stereo -t 6.5 -vf "\
crop=608:1080:660:0,scale=1080:1920,setsar=1,boxblur=8:2,eq=brightness=-0.22:saturation=0.85,\
drawtext=fontfile=$FONT:text='MAKE CLIPS LIKE THIS WITH AI':fontsize=48:fontcolor=white:borderw=5:bordercolor=black:x=(w-text_w)/2:y=770,\
drawtext=fontfile=$FONT:text='AND EARN MONEY ON MAKE.FUN':fontsize=48:fontcolor=yellow:borderw=5:bordercolor=black:x=(w-text_w)/2:y=855,\
drawtext=fontfile=$FONT:text='make.fun/bounty/gta6-clipper-01':fontsize=42:fontcolor=white:borderw=4:bordercolor=black:x=(w-text_w)/2:y=1010" \
  -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -r 30 -c:a aac -b:a 160k -ar 48000 -ac 2 build/seg_b.mp4 -y

# --- concat A + B, faststart ---
printf "file 'seg_a.mp4'\nfile 'seg_b.mp4'\n" > build/concat.txt
ffmpeg -v error -f concat -safe 0 -i build/concat.txt -c copy -movflags +faststart gta6_red_hulk_clip.mp4 -y

echo "BUILD OK"
