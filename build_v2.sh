#!/bin/bash
# gta6-clipper-01 — V2 build (facecam added), run in-session 2026-11-20
# Same moment/beats/audio/text/end-card as v1 (build.sh), but Speed's facecam
# is VISIBLE: STACKED layout — facecam panel on top (full width), gameplay below.
#
# Facecam box in the 1920x1080 source (measured on frames t=100/108/114/118,
# static overlay): crop=389:243:4:460  (x 4..393, y 460..703, bottom-left;
# edges verified — excludes the viewer-count above and sub-counter below).
#
# Layout math (output 1080x1920; ALL intermediate heights EVEN — an odd height
# gets rounded down by scale under yuv420p negotiation and breaks x264):
#   cam panel : 389x243 -> scale 1068x666 -> pad to 1080x678 (6px white border)
#   gameplay  : v1 crop x=660 w=608, source rows y=59..759 (700 rows — keeps the
#               stand-up head at y~85 and the hug zone; only the leap's peak
#               frames clip ~59px at the very top) -> scale 1080x1242
#   678 + 1242 = 1920. Text y positions are v1's, shifted into the gameplay area.
set -e
cd "$(dirname "$0")"
SRC=src/speed_hulk_source.mp4
FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf
mkdir -p build

# --- end-card background frame (same as v1: Jason mid-launch, source t=116) ---
ffmpeg -v error -ss 116 -i "$SRC" -frames:v 1 build/card_bg.png -y

# --- segment A v2: footage 96.0-120.0, stacked facecam + gameplay, burned text ---
ffmpeg -v error -ss 96 -i "$SRC" -t 24 -filter_complex "\
[0:v]split=2[game][cam];\
[game]crop=608:700:660:59,scale=1080:1242,setsar=1[game2];\
[cam]crop=389:243:4:460,scale=1068:666,pad=1080:678:6:6:white,setsar=1[cam2];\
[cam2][game2]vstack=inputs=2,\
drawtext=fontfile=$FONT:text='HE FOUND A RED HULK':fontsize=62:fontcolor=white:borderw=5:bordercolor=black:x=(w-text_w)/2:y=752:enable='between(t,0,3.5)',\
drawtext=fontfile=$FONT:text='IN GTA 6?!':fontsize=62:fontcolor=white:borderw=5:bordercolor=black:x=(w-text_w)/2:y=848:enable='between(t,0,3.5)',\
drawtext=fontfile=$FONT:text='HE JUST WANTED A HUG':fontsize=62:fontcolor=white:borderw=5:bordercolor=black:x=(w-text_w)/2:y=782:enable='between(t,4.5,9)',\
drawtext=fontfile=$FONT:text='THEN HE STOOD UP...':fontsize=62:fontcolor=white:borderw=5:bordercolor=black:x=(w-text_w)/2:y=782:enable='between(t,10.5,14.5)'[v];\
[0:a]afade=t=out:st=23:duration=1[a]" \
  -map "[v]" -map "[a]" \
  -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -r 30 -c:a aac -b:a 160k -ar 48000 -ac 2 build/seg_a_v2.mp4 -y

# --- segment B: pitch end-card, 6.5s — identical to v1 ---
ffmpeg -v error -loop 1 -i build/card_bg.png -f lavfi -i anullsrc=r=48000:cl=stereo -t 6.5 -vf "\
crop=608:1080:660:0,scale=1080:1920,setsar=1,boxblur=8:2,eq=brightness=-0.22:saturation=0.85,\
drawtext=fontfile=$FONT:text='MAKE CLIPS LIKE THIS WITH AI':fontsize=48:fontcolor=white:borderw=5:bordercolor=black:x=(w-text_w)/2:y=770,\
drawtext=fontfile=$FONT:text='AND EARN MONEY ON MAKE.FUN':fontsize=48:fontcolor=yellow:borderw=5:bordercolor=black:x=(w-text_w)/2:y=855,\
drawtext=fontfile=$FONT:text='make.fun/bounty/gta6-clipper-01':fontsize=42:fontcolor=white:borderw=4:bordercolor=black:x=(w-text_w)/2:y=1010" \
  -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -r 30 -c:a aac -b:a 160k -ar 48000 -ac 2 build/seg_b_v2.mp4 -y

# --- concat A + B, faststart ---
printf "file 'seg_a_v2.mp4'\nfile 'seg_b_v2.mp4'\n" > build/concat_v2.txt
ffmpeg -v error -f concat -safe 0 -i build/concat_v2.txt -c copy -movflags +faststart gta6_red_hulk_clip_v2.mp4 -y

echo "BUILD V2 OK"
