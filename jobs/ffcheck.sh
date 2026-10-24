#!/bin/bash
mkdir -p out
ffmpeg -version | head -1 | tee out/ff.txt
fc-list | grep -ci "noto sans cjk" | xargs -I{} echo "中文字体数: {}" | tee -a out/ff.txt
