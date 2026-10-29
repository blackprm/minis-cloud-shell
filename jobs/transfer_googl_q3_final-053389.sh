#!/bin/bash
# 云端搬运：artifact → Release。cloud.py run 本文件 --no-deps --no-fetch
# 用法：每次只改下面两个变量（ARTIFACT_ID 用 cloud.py status 的 run 查
#       /repos/<owner>/<name>/actions/runs/<run_id>/artifacts 拿到）
ARTIFACT_ID=12918873672
TAG=googl_q3_final-053389
# 产物内取最大的 mp4 传上去；文件名固定 ASCII（Release 会剥离中文名）

set -e
cd "$GITHUB_WORKSPACE"
API="https://api.github.com/repos/blackprm/minis-cloud-shell"
AUTH="Authorization: Bearer $GH_TOKEN"

echo "== download artifact $ARTIFACT_ID =="
curl -sL --retry 3 -H "$AUTH" -o art.zip "$API/actions/artifacts/$ARTIFACT_ID/zip"
ls -la art.zip
rm -rf unz && mkdir unz && cd unz && unzip -o ../art.zip > /dev/null
find . -type f -exec ls -la {} \;
BIG=$(find . -type f \( -name '*.mp4' -o -name '*.zip' -o -name '*.bin' \) -printf '%s %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)
if [ -z "$BIG" ]; then BIG=$(find . -type f | head -1); fi
echo "picked: $BIG"
EXT="${BIG##*.}"
cp "$BIG" /tmp/asset.$EXT
cd /tmp

echo "== delete old release if exists =="
RID=$(curl -s -H "$AUTH" "$API/releases/tags/$TAG" | python3 -c "import json,sys;print(json.load(sys.stdin).get('id',''))" 2>/dev/null || true)
if [ -n "$RID" ]; then
  curl -s -X DELETE -H "$AUTH" "$API/releases/$RID" -o /dev/null
  sleep 2
  curl -s -X DELETE -H "$AUTH" "$API/git/refs/tags/$TAG" -o /dev/null || true
  sleep 2
  echo "deleted old release $RID"
fi

echo "== create release =="
curl -s -X POST -H "$AUTH" -H "Accept: application/vnd.github+json" \
  "$API/releases" -d "{\"tag_name\":\"$TAG\",\"name\":\"$TAG\",\"body\":\"auto transfer\"}" -o rel.json
python3 - <<'PYEOF'
import json
d = json.load(open('/tmp/rel.json'))
print('release id:', d.get('id'), d.get('message',''))
up = (d.get('upload_url') or '').split('{')[0]
open('/tmp/up_url.txt','w').write(up)
PYEOF
UP=$(cat /tmp/up_url.txt)
if [ -z "$UP" ]; then echo "RELEASE CREATE FAILED"; cat rel.json; exit 1; fi

echo "== upload asset =="
curl -s -X POST -H "$AUTH" -H "Content-Type: application/octet-stream" \
  --data-binary @/tmp/asset.$EXT "$UP?name=asset.$EXT" -o up.json
python3 - <<'PYEOF'
import json
d = json.load(open('/tmp/up.json'))
print('asset:', d.get('name'), d.get('size'), d.get('browser_download_url') or d.get('errors') or d.get('message'))
PYEOF
echo "DONE"
