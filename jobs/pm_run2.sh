#!/bin/bash
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ROOT/out"

python3 - "$ROOT/out/pm2.txt" <<'PYEOF'
import json, urllib.request, urllib.parse, ssl, re, sys

CTX = ssl.create_default_context(); CTX.check_hostname=False; CTX.verify_mode=ssl.CERT_NONE
H = {"User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0 Safari/537.36",
     "Accept":"application/json, text/plain, */*"}
out = open(sys.argv[1],"w",encoding="utf-8")
def w(s=""):
    print(s); out.write(str(s)+"\n")
def get(url, timeout=45):
    req = urllib.request.Request(url, headers=H)
    with urllib.request.urlopen(req, timeout=timeout, context=CTX) as r:
        return r.read().decode("utf-8","ignore")

PAT = re.compile(r"(fed|fomc|rate (hike|cut)|powell|recession|cpi|inflation|interest rate|rate decision)", re.I)

w("### POLYMARKET: high-volume open events matching macro keywords ###")
seen=set()
for page in range(0,3):
    url=("https://gamma-api.polymarket.com/events?closed=false&limit=250&offset=%d"
         "&order=volume24hr&ascending=false" % (page*250))
    try:
        d=json.loads(get(url))
    except Exception as e:
        w("PAGE %d ERR %s %s"%(page,type(e).__name__,e)); continue
    if not d: break
    w("\n--- page %d, n=%d ---"%(page,len(d)))
    for e in d:
        t=e.get("title") or ""
        if not PAT.search(t): continue
        if e.get("slug") in seen: continue
        seen.add(e.get("slug"))
        w("\n== %s\n   slug=%s  end=%s  vol=%s  liq=%s  vol24=%s"%(
            t, e.get("slug"), e.get("endDate"), e.get("volume"),
            e.get("liquidity"), e.get("volume24hr")))
        for m in (e.get("markets") or []):
            ops=m.get("outcomes"); pr=m.get("outcomePrices")
            chg1=m.get("oneDayPriceChange"); chg7=m.get("oneWeekPriceChange")
            w("   * %-28s | %s | %s | d1=%s w1=%s | vol=%s"%(
                str(m.get("groupItemTitle") or m.get("question"))[:28], ops, pr, chg1, chg7, m.get("volume")))

w("\n\n### KALSHI PROBES ###")
for path in ["exchange/status","series?category=Economics","series/KXFEDDECISION","series/KXFED",
             "events?limit=100&status=open","markets?limit=50&status=open"]:
    url="https://api.elections.kalshi.com/trade-api/v1/"+path
    w("\n[K] "+url)
    try:
        raw=get(url,30)
    except Exception as e:
        w("   ERR %s %s"%(type(e).__name__,e)); continue
    w("   len=%d  head=%s"%(len(raw), raw[:400].replace("\n"," ")))
    try: d=json.loads(raw)
    except: continue
    if "series" in d:
        for s in d["series"][:40]:
            w("     series %s | %s | %s"%(s.get("ticker"),s.get("title"),s.get("category")))
    if "events" in d:
        for e in d["events"][:60]:
            if re.search(r"(fed|rate|fomc|cpi|inflation|recession)", (e.get("title") or "")+(e.get("event_ticker") or ""), re.I):
                w("     event %s | %s | %s"%(e.get("event_ticker"),e.get("title"),e.get("sub_title")))
    if "markets" in d:
        for m in d["markets"][:60]:
            if re.search(r"(fed|rate|fomc|cpi|inflation|recession)", (m.get("ticker") or "")+(m.get("title") or ""), re.I):
                w("     mkt %s | %s | yes_bid=%s yes_ask=%s last=%s vol=%s"%(m.get("ticker"),m.get("title"),m.get("yes_bid"),m.get("yes_ask"),m.get("last_price"),m.get("volume")))

out.close()
PYEOF
echo "SIZE: $(wc -c < "$ROOT/out/pm2.txt")"
