#!/bin/bash
set +e
mkdir -p dl
UA="Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
VID="v0300fg10000d112f87og65pnc5i9b60"
NAME="dy_v0300fg10000d112f87og65pnc5i9b60_1792898557.mp4"
for R in 1080p 720p; do
  U="https://aweme.snssdk.com/aweme/v1/play/?video_id=$VID&ratio=$R&line=0"
  echo "== try $R"
  curl -sL -m 3000 -A "$UA" -o "dl/$NAME" -w "http=%{http_code} size=%{size_download} speed=%{speed_download}B/s\n" "$U"
  SZ=$(stat -c%s "dl/$NAME" 2>/dev/null || echo 0)
  echo "got=$SZ"
  if [ "$SZ" -gt 50000 ]; then echo "OK ratio=$R size=$SZ"; break; fi
done
SZ=$(stat -c%s "dl/$NAME" 2>/dev/null || echo 0)
if [ "$SZ" -lt 50000 ]; then echo "FAIL_DOWNLOAD"; exit 0; fi
echo "RELEASE_FILE=$NAME"
echo "RELEASE_SIZE=$SZ"
gh release view dy-files >/dev/null 2>&1 || gh release create dy-files -t "dy temp" -n "临时视频，下载后自动清理"
gh release upload dy-files "dl/$NAME" --clobber && echo "UPLOAD_OK"
