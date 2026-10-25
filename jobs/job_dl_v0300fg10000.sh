#!/bin/bash
set +e
mkdir -p out
UA='Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1'
VID='v0300fg10000d112f87og65pnc5i9b60'
for R in 1080p 720p 540p; do
  U="https://aweme.snssdk.com/aweme/v1/play/?video_id=$VID&ratio=$R&line=0"
  echo "尝试 $R ..."
  curl -sL -m 3300 -A "$UA" -H "Referer: https://www.douyin.com/" \
       -o out/video.mp4 \
       -w "http=%{http_code} size=%{size_download} speed=%{speed_download}B/s\n" "$U"
  SZ=$(stat -c%s out/video.mp4 2>/dev/null || echo 0)
  echo "得到 $SZ bytes"
  if [ "$SZ" -gt 50000 ]; then echo "OK ratio=$R size=$SZ"; break; fi
done
head -c 12 out/video.mp4 | xxd -p
ls -la out/
echo "云端下载完成"
