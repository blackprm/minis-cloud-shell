#!/bin/bash
set -e
cd "$GITHUB_WORKSPACE"
mkdir -p pkg && cd pkg
echo "[$(date +%T)] downloading pkg"
curl -sL https://github.com/blackprm/minis-cloud-shell/releases/download/tsmc-pkg-1028/pkg.tgz -o pkg.tgz
ls -la pkg.tgz
tar xzf pkg.tgz
if ! command -v ffmpeg >/dev/null; then sudo apt-get update -qq && sudo apt-get install -y -qq ffmpeg; fi
ffmpeg -version | head -1; echo "[$(date +%T)] ffmpeg ready"
npm i puppeteer --silent --no-fund --no-audit; echo "[$(date +%T)] puppeteer ready"
node render.js . 30 frames
ls frames | wc -l; echo "[$(date +%T)] frames done"
ffmpeg -y -hide_banner -loglevel error -framerate 30 -i frames/f%06d.jpg -i audio.wav -c:v libx264 -preset veryfast -crf 19 -pix_fmt yuv420p -c:a aac -b:a 192k -shortest "$GITHUB_WORKSPACE/out/tsmc.mp4"
ffmpeg -y -hide_banner -loglevel error -i "$GITHUB_WORKSPACE/out/tsmc.mp4" -i bgm.m4a -filter_complex "[1:a]volume=0.12[b];[0:a][b]amix=inputs=2:duration=first[a]" -map 0:v -map "[a]" -c:v copy -c:a aac -b:a 192k "$GITHUB_WORKSPACE/out/tsmc_bgm.mp4"
ls -la "$GITHUB_WORKSPACE/out"
