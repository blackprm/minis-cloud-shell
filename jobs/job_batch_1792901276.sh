#!/bin/bash
set +e
mkdir -p dl
UA="Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
VIDS=("v0300fg10000d112f87og65pnc5i9b60" "v0200fg10000d04ac0fog65pn76hr8m0")
NAMES=("dy_7og65pnc5i9b60_0.mp4" "dy_fog65pn76hr8m0_1.mp4")
for i in "${!VIDS[@]}"; do
  VID="${VIDS[$i]}"; NAME="${NAMES[$i]}"
  echo "=== $i $VID -> $NAME"
  for R in 1080p 720p; do
    U="https://aweme.snssdk.com/aweme/v1/play/?video_id=$VID&ratio=$R&line=0"
    curl -sL -m 5400 -A "$UA" -o "dl/$NAME" \
      -w "http=%{http_code} size=%{size_download} speed=%{speed_download}B/s\n" "$U"
    SZ=$(stat -c%s "dl/$NAME" 2>/dev/null || echo 0)
    echo "ratio=$R size=$SZ"
    if [ "$SZ" -gt 50000 ]; then break; fi
  done
  SZ=$(stat -c%s "dl/$NAME" 2>/dev/null || echo 0)
  if [ "$SZ" -lt 50000 ]; then echo "FAIL $VID"; rm -f "dl/$NAME"; continue; fi
  echo "READY $NAME $SZ"
done
ls -la dl/
gh release view dy-files >/dev/null 2>&1 || gh release create dy-files -t "dy temp" -n "临时视频文件，下载后自动清理"
for f in dl/*; do
  [ -f "$f" ] || continue
  echo "UPLOAD $(basename $f)"
  gh release upload dy-files "$f" --clobber && echo "UPLOAD_OK $(basename $f)"
done
echo "DONE"
