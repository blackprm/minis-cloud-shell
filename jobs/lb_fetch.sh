#!/bin/bash
set -u
mkdir -p out
UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"
URL="https://longbridge.com/topics/45055048?locale=zh-CN&channel=SH000001"
echo "== fetch $URL"
curl -sSL -m 60 -A "$UA" -H "Accept-Language: zh-CN,zh;q=0.9" "$URL" -o out/page.html -w "http=%{http_code} size=%{size_download}\n"
ls -l out/
python3 - <<'PY'
import re, html, json, os
p='out/page.html'
if not os.path.exists(p):
    print('no html'); raise SystemExit
s=open(p, encoding='utf-8', errors='ignore').read()
print('== len', len(s))
m=re.search(r'<title[^>]*>(.*?)</title>', s, re.S)
print('== title:', html.unescape(m.group(1)).strip() if m else None)
# 找内嵌 JSON
for tag in ['__NEXT_DATA__','__NUXT__','__INITIAL_STATE__','window.__APOLLO_STATE__']:
    i=s.find(tag)
    print('==', tag, 'at', i)
# 文本化
t=re.sub(r'<script.*?</script>','',s,flags=re.S|re.I)
t=re.sub(r'<style.*?</style>','',t,flags=re.S|re.I)
t=re.sub(r'<[^>]+>','\n',t)
t=html.unescape(t)
lines=[l.strip() for l in t.split('\n')]
lines=[l for l in lines if l]
txt='\n'.join(lines)
print('== TEXT ==')
print(txt[:6000])
open('out/text.txt','w',encoding='utf-8').write(txt)
# 打印脚本体里可能的正文 JSON
for kw in ['"content"','"text"','"title"']:
    for mm in list(re.finditer(kw, s))[:3]:
        a=max(0,mm.start()-200); print('--- snippet', kw, '---'); print(s[a:mm.start()+800].replace('\n',' ')[:1000])
PY
