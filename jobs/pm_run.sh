#!/bin/bash
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ROOT/out"

python3 - "$ROOT/out/pm.txt" <<'PYEOF'
import json, urllib.request, ssl, sys

CTX = ssl.create_default_context()
CTX.check_hostname = False
CTX.verify_mode = ssl.CERT_NONE
H = {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0 Safari/537.36",
     "Accept": "application/json, text/plain, */*"}

out = open(sys.argv[1], "w", encoding="utf-8")

def w(s=""):
    print(s)
    out.write(str(s) + "\n")

def get(url, timeout=30):
    req = urllib.request.Request(url, headers=H)
    with urllib.request.urlopen(req, timeout=timeout, context=CTX) as r:
        return r.read().decode("utf-8", "ignore")

def show_pm(url, tag):
    w("\n" + "="*72)
    w("[POLY] " + tag)
    w(url)
    try:
        raw = get(url)
    except Exception as e:
        w("  ERR %s %s" % (type(e).__name__, e)); return
    try:
        d = json.loads(raw)
    except Exception as e:
        w("  PARSE %s | %s" % (e, raw[:200])); return
    if isinstance(d, dict):
        d = d.get("data") or d.get("events") or d.get("markets") or [d]
    w("  n = %d" % len(d))
    for e in d[:15]:
        w("  -- " + str(e.get("title") or e.get("question") or e.get("slug")))
        for m in (e.get("markets") or [])[:12]:
            q = m.get("groupItemTitle") or m.get("question")
            w("     * %s | %s | %s | vol=%s liq=%s" % (
                q, m.get("outcomes"), m.get("outcomePrices"),
                m.get("volume"), m.get("liquidity")))

def show_kalshi(path, tag, params=""):
    url = "https://api.elections.kalshi.com/trade-api/v1/" + path + params
    w("\n" + "="*72)
    w("[KALSHI] " + tag)
    w(url)
    try:
        raw = get(url)
    except Exception as e:
        w("  ERR %s %s" % (type(e).__name__, e)); return
    try:
        d = json.loads(raw)
    except Exception as e:
        w("  PARSE %s | %s" % (e, raw[:300])); return
    if "events" in d:
        for e in d["events"][:15]:
            w("  -- %s | %s | %s" % (e.get("event_ticker"), e.get("title"), e.get("sub_title")))
    if "markets" in d:
        for m in d["markets"][:30]:
            w("  * %s | %s | yes_bid=%s yes_ask=%s last=%s vol=%s oi=%s status=%s" % (
                m.get("ticker"), m.get("title") or m.get("yes_sub_title"),
                m.get("yes_bid"), m.get("yes_ask"), m.get("last_price"),
                m.get("volume"), m.get("open_interest"), m.get("status")))

show_pm("https://gamma-api.polymarket.com/events?closed=false&limit=60&order=volume24hr&ascending=false&search=fed", "search=fed")
show_pm("https://gamma-api.polymarket.com/events?closed=false&limit=60&order=volume24hr&ascending=false&search=rate%20hike", "search=rate hike")
show_pm("https://gamma-api.polymarket.com/events?closed=false&limit=40&order=volume24hr&ascending=false&search=jerome%20powell", "search=powell")
show_pm("https://gamma-api.polymarket.com/events?closed=false&limit=40&order=volume24hr&ascending=false&search=inflation", "search=inflation")

show_kalshi("events", "KXFEDDECISION", "?series_ticker=KXFEDDECISION&status=open&limit=20")
show_kalshi("markets", "KXFEDDECISION", "?series_ticker=KXFEDDECISION&status=open&limit=60")
show_kalshi("events", "KXFED", "?series_ticker=KXFED&status=open&limit=20")
show_kalshi("markets", "KXFED", "?series_ticker=KXFED&status=open&limit=60")
show_kalshi("markets", "KXCPI", "?series_ticker=KXCPI&status=open&limit=20")

out.close()
PYEOF

echo "SIZE: $(wc -c < "$ROOT/out/pm.txt")"
