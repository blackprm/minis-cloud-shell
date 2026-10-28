#!/bin/bash
set -e
cd $GITHUB_WORKSPACE
mkdir -p pkg out
cd pkg
curl -sL https://github.com/blackprm/minis-cloud-shell/releases/download/tsmc-pkg-1028/pkg.tgz -o pkg.tgz
tar xzf pkg.tgz
if ! command -v ffmpeg >/dev/null 2>&1; then sudo apt-get install -y -qq ffmpeg >/dev/null 2>&1; fi
fc-list 2>/dev/null | grep -qi "CJK" || sudo apt-get install -y -qq fonts-noto-cjk >/dev/null 2>&1
echo "[$(date +%T)] render start"
node render.js . 30 frames
echo "[$(date +%T)] frames: $(ls frames | wc -l)"
ffmpeg -y -framerate 30 -i frames/f%05d.png -i audio.wav -c:v libx264 -crf 19 -preset veryfast -pix_fmt yuv420p -shortest $GITHUB_WORKSPACE/out/tsmc.mp4
ffmpeg -y -i $GITHUB_WORKSPACE/out/tsmc.mp4 -i bgm.m4a -filter_complex "[1:a]volume=0.18,afade=t=out:st=74:d=4[b];[0:a][b]amix=inputs=2:duration=first[a]" -map 0:v -map "[a]" -c:v copy -c:a aac $GITHUB_WORKSPACE/out/tsmc_bgm.mp4
echo "[$(date +%T)] done"
ls -la $GITHUB_WORKSPACE/out
