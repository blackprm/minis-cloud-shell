#!/bin/bash
# 测试云端无头 chromium 能否渲染 m.douyin.com 分享页并拿到 video_id
set +e
mkdir -p out
UA="Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"

echo "=== chromium 版本 ==="
chromium --version 2>&1 | head -2

for TAG in new old; do
  if [ "$TAG" = "new" ]; then MODE="--headless=new"; else MODE="--headless"; fi
  echo
  echo "===== 尝试 $MODE ====="
  timeout 90 chromium $MODE --no-sandbox --disable-gpu --disable-dev-shm-usage \
    --user-agent="$UA" --virtual-time-budget=20000 \
    --window-size=390,844 \
    --dump-dom "https://m.douyin.com/share/video/7512612489643068699" \
    > "out/dom_$TAG.html" 2> "out/err_$TAG.txt"
  echo "退出码: $?"
  echo "DOM 大小: $(stat -c%s "out/dom_$TAG.html" 2>/dev/null)"
  echo "--- video_id 命中 ---"
  grep -o 'video_id=v0[a-zA-Z0-9]*' "out/dom_$TAG.html" 2>/dev/null | head -3
  echo "--- video 标签 ---"
  grep -o '<video[^>]\{0,200\}' "out/dom_$TAG.html" 2>/dev/null | head -2
  echo "--- 页面 title ---"
  grep -o '<title>[^<]*' "out/dom_$TAG.html" 2>/dev/null | head -1
  echo "--- 错误输出前 5 行 ---"
  head -5 "out/err_$TAG.txt" 2>/dev/null
done

echo
echo "===== 完毕 ====="
ls -la out/
