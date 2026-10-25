#!/bin/bash
# 探测抖音相关域名在 GitHub Actions 出口 IP 下的可达性
set +e
mkdir -p out
VID=v0300fg10000d112f87og65pnc5i9b60
UA="Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"

echo "===== 出口 IP ====="
curl -s -m 12 https://api.ipify.org; echo
curl -s -m 12 http://ip-api.com/line/?fields=country,city,isp 2>/dev/null | tr '\n' ' '; echo

echo
echo "===== 1) 视频 CDN: aweme.snssdk.com（只取前 2MB）====="
curl -sL -m 60 -A "$UA" -r 0-2097151 \
  -o out/probe_snssdk.mp4 \
  -w "http=%{http_code} size=%{size_download} type=%{content_type} speed=%{speed_download}B/s\n" \
  "https://aweme.snssdk.com/aweme/v1/play/?video_id=$VID&ratio=720p&line=0"
echo "文件头: $(head -c 12 out/probe_snssdk.mp4 | xxd -p)"
echo "文件大小: $(stat -c%s out/probe_snssdk.mp4 2>/dev/null) bytes"
head -c 200 out/probe_snssdk.mp4 | strings | head -3

echo
echo "===== 2) 另一个 CDN: m.douyin.com playwm ====="
curl -sL -m 60 -A "$UA" -r 0-1048575 \
  -o out/probe_playwm.mp4 \
  -w "http=%{http_code} size=%{size_download} type=%{content_type}\n" \
  "https://m.douyin.com/aweme/v1/playwm/?video_id=$VID&ratio=720p&line=0"

echo
echo "===== 3) 网页: m.douyin.com 分享页 ====="
curl -sL -m 25 --compressed -A "$UA" -o out/m.html \
  -w "http=%{http_code} url=%{url_effective} size=%{size_download}\n" \
  "https://m.douyin.com/share/video/7512612489643068699"
echo "含 video_id 次数: $(grep -c 'video_id' out/m.html 2>/dev/null || echo 0)"
echo "含 _ROUTER_DATA 次数: $(grep -c '_ROUTER_DATA' out/m.html 2>/dev/null || echo 0)"

echo
echo "===== 4) iesdouyin 分享页 ====="
curl -sL -m 25 --compressed -A "$UA" -o out/i.html \
  -w "http=%{http_code} size=%{size_download}\n" \
  "https://www.iesdouyin.com/share/video/7512612489643068699/"
echo "含 videoInfoRes: $(grep -c 'videoInfoRes' out/i.html 2>/dev/null || echo 0)"

echo
echo "===== 5) 无头浏览器可用性 ====="
which chromium chromium-browser google-chrome 2>/dev/null
node -e "console.log('node', process.version)" 2>/dev/null

echo
echo "===== 完毕 ====="
