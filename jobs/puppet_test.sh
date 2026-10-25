#!/bin/bash
# 用 puppeteer-core 驱动系统 chromium，测试云端能否渲染抖音分享页
set +e
ORIG=$PWD
mkdir -p out
WORK=/tmp/pw
rm -rf $WORK && mkdir -p $WORK && cd $WORK
npm init -y > /dev/null 2>&1
echo "=== 安装 puppeteer-core ==="
npm i puppeteer-core --silent --no-audit --no-fund 2>&1 | tail -3
echo "安装完成: $(ls node_modules | head -3 | tr '\n' ' ')"

cat > t.js <<'JSEOF'
const puppeteer = require('puppeteer-core');
const UA = 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1';
(async () => {
  const url = process.argv[2];
  const b = await puppeteer.launch({
    executablePath: '/usr/bin/chromium',
    headless: true,
    args: ['--no-sandbox', '--disable-dev-shm-usage', '--disable-gpu',
           '--disable-blink-features=AutomationControlled', '--no-zygote']
  });
  const p = await b.newPage();
  await p.setUserAgent(UA);
  await p.setViewport({ width: 390, height: 844, isMobile: true, hasTouch: true, deviceScaleFactor: 2 });
  p.on('console', m => { const t = m.text(); if (/error/i.test(t)) console.log('[console]', t.slice(0, 120)); });
  const resp = await p.goto(url, { waitUntil: 'domcontentloaded', timeout: 60000 })
      .catch(e => { console.log('goto_err:', e.message); return null; });
  console.log('http_status:', resp ? resp.status() : 'none');
  let found = null;
  for (let i = 0; i < 45; i++) {
    found = await p.evaluate(() => {
      const v = document.querySelector('video');
      const h = document.documentElement.innerHTML;
      const m = h.match(/video_id=(v0[0-9a-zA-Z]{10,})/);
      return { src: v ? v.src : null, vid: m ? m[1] : null,
               title: document.title, body: document.body.innerText.slice(0, 160),
               nvideo: document.querySelectorAll('video').length,
               nimg: document.querySelectorAll('img').length };
    }).catch(e => ({ err: e.message }));
    if (found && (found.vid || (found.src && found.src.indexOf('http') === 0))) break;
    await new Promise(r => setTimeout(r, 1000));
  }
  console.log('RESULT:', JSON.stringify(found, null, 1));
  await p.screenshot({ path: 'out/shot.png' }).catch(() => {});
  await b.close();
})().catch(e => { console.log('FATAL:', e.message); process.exit(1); });
JSEOF

node t.js "https://m.douyin.com/share/video/7512612489643068699" 2>&1 | grep -v 'dbus\|Fontconfig\|GPU\|sandbox' | head -40
echo
echo "=== 完毕 ==="
cp -r $WORK/out/. $ORIG/out/ 2>/dev/null
ls -la $ORIG/out/
