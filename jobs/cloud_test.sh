#!/bin/bash
set -e
echo "=== 云端机器信息 ==="
hostname; uname -m; nproc; free -h | head -2 | tail -1
echo
echo "=== 工具版本 ==="
python3 --version
node --version 2>/dev/null || echo "node 未安装"
ffmpeg -version 2>/dev/null | head -1 || echo "ffmpeg 未安装"
echo
mkdir -p out
echo "Minis 云端执行测试成功 $(date -u)" > out/result.txt
python3 - <<'PY'
import math
with open('out/calc.txt','w') as f:
    f.write(f"pi^2 = {math.pi**2:.6f}\n")
PY
echo "=== 产物 ==="
ls -lh out/
