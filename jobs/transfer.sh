#!/bin/bash
set -e
cd "$GITHUB_WORKSPACE"
echo "== download artifact 12602600175 =="
curl -sL --retry 3 -H "Authorization: Bearer $GH_TOKEN" -o art.zip \
  "https://api.github.com/repos/blackprm/minis-cloud-shell/actions/artifacts/12602600175/zip"
ls -la art.zip
mkdir -p unz && cd unz && unzip -o ../art.zip > /dev/null
find . -type f -exec ls -la {} \;
MP4=$(find . -type f -name '*.mp4' | head -1)
if [ -z "$MP4" ]; then echo "NO MP4 FOUND"; exit 1; fi
echo "MP4: $MP4 size=$(stat -c%s "$MP4")"
cd "$GITHUB_WORKSPACE"
echo "== create release =="
gh release delete nvda-out --yes --cleanup-tag 2>/dev/null || true
gh release create nvda-out "$MP4" --title "nvda render output" --notes "auto transfer from artifact"
echo "== verify =="
gh release view nvda-out --json assets --jq '.assets[] | {name, size}'
echo "URL: https://github.com/blackprm/minis-cloud-shell/releases/download/nvda-out/$(basename "$MP4")"
echo "DONE"
