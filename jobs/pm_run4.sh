#!/bin/bash
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ROOT/out"

python3 - "$ROOT/out/pm4.txt" <<'PYEOF'
import json, urllib.request, urllib.parse, urllib.error, ssl, sys, re

CTX=ssl.create_default_context(); CTX.check_hostname=False; CTX.verify_mode=ssl.CERT_NONE
UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0 Safari/537.36"
out=open(sys.argv[1],"w",encoding="utf-8")
def w(s=""):
    print(s); out.write(str(s)+"\n")
def get(url):
    req=urllib.request.Request(url, headers={"User-Agent":UA,"Accept":"application/json"})
    try:
        with urllib.request.urlopen(req, timeout=45, context=CTX) as r:
            return r.status, r.read().decode("utf-8","ignore")
    except urllib.error.HTTPError as e:
        try: b=e.read().decode("utf-8","ignore")[:200]
        except: b=""
        return e.code, b
    except Exception as e:
        return -1, "%s %s"%(type(e).__name__,e)

# ============ KALSHI v2 ============
w("### KALSHI v2 ###")
for path in ["series?category=Economics&limit=100",
             "events?series_ticker=KXFEDDECISION&status=open&limit=20",
             "markets?series_ticker=KXFEDDECISION&status=open&limit=60"]:
    u="https://api.elections.kalshi.com/trade-api/v2/"+path
    c,b=get(u)
    w("\n%s -> %s len=%d"%(u,c,len(b)))
    if c!=200:
        w("  "+b[:150]); continue
    try: d=json.loads(b)
    except Exception as e:
        w("  parse %s"%e); continue
    if "series" in d:
        for s in d["series"]:
            tt=(s.get("title") or "")
            if re.search(r"(fed|rate|fomc|inflation|cpi|recession)", tt, re.I):
                w("  series %s | %s"%(s.get("ticker"), tt))
    if "events" in d:
        for e in d["events"]:
            w("  event %s | %s | %s"%(e.get("event_ticker"), e.get("title"), e.get("sub_title")))
    if "markets" in d:
        for m in d["markets"]:
            w("  * %s | %s | yes_bid=%s yes_ask=%s last=%s vol=%s oi=%s"%(m.get("ticker"), m.get("yes_sub_title") or m.get("title"), m.get("yes_bid"), m.get("yes_ask"), m.get("last_price"), m.get("volume"), m.get("open_interest")))

# ============ POLYMARKET single event by slug ============
w("\n\n### POLY EVENT DETAIL ###")
u="https://gamma-api.polymarket.com/events?slug=fed-decision-in-december-20260729232808632"
c,b=get(u)
w("%s -> %s len=%d"%(u,c,len(b)))
if c==200:
    try:
        d=json.loads(b)
        e=d[0] if isinstance(d,list) and d else d
        w("title=%s"%e.get("title"))
        w("endDate=%s  startDate=%s"%(e.get("endDate"), e.get("startDate")))
        w("volume=%s volume24hr=%s liquidity=%s"%(e.get("volume"), e.get("volume24hr"), e.get("liquidity")))
        w("description=%s"%(str(e.get("description"))[:400]))
        for m in e.get("markets") or []:
            w("  * %-22s bid=%s ask=%s last=%s spread=%s vol=%s liq=%s"%(
                m.get("groupItemTitle"), m.get("bestBid"), m.get("bestAsk"),
                m.get("lastTradePrice"), m.get("spread"), m.get("volume"), m.get("liquidity")))
    except Exception as ex:
        w("parse %s point=%s"%(ex,b[:200]))

# ============ POLYMARKET public search ============
w("\n\n### POLY PUBLIC SEARCH ###")
for q in ["fed decision","rate","inflation","recession","powell"]:
    u="https://gamma-api.polymarket.com/public-search?q="+q.replace(" ","%20")+"&limit_per_type=12"
    c,b=get(u)
    w("\n[%s] %s len=%d"%(q,c,len(b)))
    if c!=200:
        w("  "+b[:150]); continue
    try: d=json.loads(b)
    except Exception as e:
        w("  parse %s"%e); continue
    for ev in (d.get("events") or [])[:12]:
        w("  == %s | slug=%s | vol=%s | end=%s"%(ev.get("title"), ev.get("slug"), ev.get("volume"), (ev.get("endDate") or "")[:10]))

out.close()
PYEOF
echo "SIZE: $(wc -c < "$ROOT/out/pm4.txt")"
