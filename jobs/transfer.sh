#!/bin/bash
set -e
cd "$GITHUB_WORKSPACE"
API="https://api.github.com/repos/blackprm/minis-cloud-shell"
AUTH="Authorization: Bearer $GH_TOKEN"

echo "== download artifact =="
curl -sL --retry 3 -H "$AUTH" -o art.zip "$API/actions/artifacts/12602600175/zip"
ls -la art.zip
rm -rf unz && mkdir unz && cd unz && unzip -o ../art.zip > /dev/null
find . -type f -exec ls -la {} \;
MP4=$(find . -type f -name '*.mp4' | head -1)
if [ -z "$MP4" ]; then echo "NO MP4"; exit 1; fi
cp "$MP4" /tmp/nvda_out.mp4
echo "copied: $(stat -c%s /tmp/nvda_out.mp4) bytes"

cd /tmp
echo "== delete old release if exists =="
RID=$(curl -s -H "$AUTH" "$API/releases/tags/nvda-out" | python3 -c "import json,sys;print(json.load(sys.stdin).get('id',''))" 2>/dev/null || true)
if [ -n "$RID" ]; then
  curl -s -X DELETE -H "$AUTH" "$API/releases/$RID" -o /dev/null
  sleep 2
  curl -s -X DELETE -H "$AUTH" "$API/git/refs/tags/nvda-out" -o /dev/null || true
  sleep 2
  echo "deleted old release $RID"
fi

echo "== create release =="
curl -s -X POST -H "$AUTH" -H "Accept: application/vnd.github+json" \
  "$API/releases" \
  -d '{"tag_name":"nvda-out","name":"nvda render output","body":"auto transfer"}' -o rel.json
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
curl -s -X POST -H "$AUTH" -H "Content-Type: video/mp4" \
  --data-binary @/tmp/nvda_out.mp4 "$UP?name=nvda_out.mp4" -o up.json
python3 - <<'PYEOF'
import json
d = json.load(open('/tmp/up.json'))
print('asset:', d.get('name'), d.get('size'), d.get('browser_download_url') or d.get('errors') or d.get('message'))
PYEOF
echo "DONE"
