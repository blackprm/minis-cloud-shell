#!/bin/bash
# 最小示例：看看云端机器是什么配置，并产出一个文件到 out/
set -e
mkdir -p out

echo "=== step 1 机器信息 ==="
uname -a
nproc
free -h | head -2
df -h / | tail -1

echo "=== step 2 工具版本 ==="
python3 --version
node -v
ffmpeg -version | head -1
fc-list | grep -ci "noto sans cjk" || true

echo "=== step 3 干活 ==="
python3 - <<'PY'
import math, json, platform
data = {str(i): round(math.sin(i / 10), 4) for i in range(50)}
json.dump(data, open('out/sin.json', 'w'), indent=1)
print('写好了 50 个点')
PY
echo "hello from cloud $(date -u +%FT%TZ)" > out/hello.txt

echo "=== step 4 完成 ==="
ls -lh out/
