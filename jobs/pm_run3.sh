#!/bin/bash
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ROOT/out"

python3 - "$ROOT/out/pm3.txt" <<'PYEOF'
import json, urllib.request, urllib.parse, urllib.error, ssl, sys, re

CTX=ssl.create_default_context(); CTX.check_hostname=False; CTX.verify_mode=ssl.CERT_NONE
UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0 Safari/537.36"
out=open(sys.argv[1],"w",encoding="utf-8")
def w(s=""):
    print(s); out.write(str(s)+"\n")

def get(url, accept="application/json"):
    req=urllib.request.Request(url, headers={"User-Agent":UA,"Accept":accept})
    try:
        with urllib.request.urlopen(req, timeout=40, context=CTX) as r:
            return r.status, r.read().decode("utf-8","ignore")
    except urllib.error.HTTPError as e:
        try: body=e.read().decode("utf-8","ignore")[:300]
        except: body=""
        return e.code, body
    except Exception as e:
        return -1, "%s %s"%(type(e).__name__, e)

# ---------- KALSHI probes ----------
w("### KALSHI PROBE ###")
cands=[
 "https://api.elections.kalshi.com/trade-api/v1/exchange/status",
 "https://api.elections.kalshi.com/trade-api/v2/exchange/status",
 "https://api.kalshi.com/trade-api/v1/exchange/status",
 "https://trading-api.kalshi.com/trade-api/v1/exchange/status",
 "https://api.elections.kalshi.com/",
 "https://api.elections.kalshi.com/trade-api/v1/series?category=Economics&limit=5",
]
for u in cands:
    c,b=get(u)
    w("%s -> %s | %s"%(u,c,b[:160].replace("\n"," ")))

# ---------- POLYMARKET ----------
w("\n### POLYMARKET SEARCHES ###")
queries=["fed decision","rate hike","powell","fomc","recession","inflation","fed funds"]
for q in queries:
    u=("https://gamma-api.polymarket.com/events?closed=false&limit=30&order=volume24hr"
       "&ascending=false&search="+urllib.parse.quote(q)) if False else \
      ("https://gamma-api.polymarket.com/events?closed=false&limit=30&order=volume24hr&ascending=false&search="+q.replace(" ","%20"))
    c,b=get(u)
    w("\n[%s] %s  len=%s"%(q,c,len(b)))
    if c!=200:
        w("   %s"%b[:200]); continue
    try: d=json.loads(b)
    except Exception as e:
        w("   parse %s"%e); continue
    for e in d[:10]:
        t=e.get("title") or ""
        if not re.search(r"(fed|fomc|rate|powell|recession|inflation|cpi)", t, re.I): continue
        w("  == %s | slug=%s | end=%s | vol=%s | vol24=%s"%(
            t, e.get("slug"), (e.get("endDate") or "")[:10], e.get("volume"), e.get("volume24hr")))
        for m in (e.get("markets") or [])[:12]:
            w("     * %-30s | %s | %s | d1=%s w1=%s | vol=%s"%(
                str(m.get("groupItemTitle") or m.get("question"))[:30],
                m.get("outcomes"), m.get("outcomePrices"),
                m.get("oneDayPriceChange"), m.get("oneWeekPriceChange"), m.get("volume")))

out.close()
PYEOF
echo "SIZE: $(wc -c < "$ROOT/out/pm3.txt")"
