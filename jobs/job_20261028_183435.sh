#!/bin/bash
set -u
OUT="$GITHUB_WORKSPACE/out"
mkdir -p "$OUT"
nproc; free -h | head -2
W=/tmp/vo; mkdir -p "$W"; cd "$W"
echo "== fetch binary"
curl -sL --retry 3 -o b.tgz "https://github.com/HoppouAI/Breeze-TTS-2.cpp/releases/download/v0.1.3/breeze-tts-2-v0.1.3-linux-x64-vulkan.tar.gz"
tar xzf b.tgz || { echo "TAR FAILED"; exit 1; }
BIN=$(find . -name breeze-cli -type f | head -1)
chmod +x "$BIN" 2>/dev/null
export LD_LIBRARY_PATH="$(dirname "$BIN"):${LD_LIBRARY_PATH:-}"
echo "== fetch model"
curl -sL --retry 3 -o m.gguf "https://huggingface.co/HoppouAI/Breeze-TTS-2.cpp/resolve/main/breeze-tts-2-q8_0.gguf"
ls -l m.gguf || exit 1

echo "== tasks: 1"

# --- 1: 01

printf %s "dHNtYy9zYW1wbGUudHh0" | base64 -d > "$W/t1.txt"

printf %s "5LqM5Y2B5YWr5bKB55S35oCn77yM5aOw6Z+z5L2O5rKJ5pyJ56OB5oCn77yM5oqW6Z+z54Ot6Zeo6Kej6K+06IWU77yM6K+t6YCf5b+r6IqC5aWP57Sn77yM6YeN54K56K+N5Yqg6YeN5ZKs5a2X77yM5Y+l5bC+5bmy6ISG5Yip6JC977yM5oOF57uq6aWx5ruh5pyJ5Yay5Yqy77yM5YOP5Y2D5LiH57KJ6LSi57uP6Kej6K+05Y2a5Li7" | base64 -d > "$W/i1.txt"

TXT="$(cat "$W/t1.txt")"
INS="$(cat "$W/i1.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 42 --cpu --output "$OUT/01.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "01.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/01.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"


echo "== durations"
python3 - "$OUT" <<'PY'
import wave,glob,os,sys
for f in sorted(glob.glob(sys.argv[1]+'/*.wav')):
    w=wave.open(f); print(os.path.basename(f), round(w.getnframes()/w.getframerate(),2),'s', w.getframerate(),'Hz')
PY
echo ALLDONE
