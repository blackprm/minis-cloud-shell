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

printf %s "5aaC5p6c5L2g5ZyoMTk5MeW5tO+8jOaKiuS4gOS4h+Wdl++8jOaKlei/m+i/meWbm+S4quW4guWcuuOAguS7iuWkqe+8jOS8muWPmOaIkOWkmuWwke+8n+S4nOS6rO+8jOWFq+S4h+OAgummluWwlO+8jOS6jOWNgeWFq+S4h+OAgue6vee6pu+8jOS6lOWNgeS4h+OAguS4iua1t++8jOWbm+WNgeS5neS4h+OAgg==" | base64 -d > "$W/t1.txt"

printf %s "5LiJ5Y2B5LqU5bKB55S35oCn77yM5Lit5L2O6Z+z77yM6IO46IWU5YWx6bij5omO5a6e77yM6K+t6YCf5Lit562J77yM5pWw5a2X5YmN5ZCO6Ieq54S25pat5byA5LiN6L+e6K+777yM6K+t5rCU5YWL5Yi25Yeg5LmO5LiN5bim5oOF57uq6LW35LyP77yM5Y+l5bC+5bmy6ISG5LiL5rKJ77yM5YOP5Zyo5b+15LiA5Lu95LiN5a65572u55aR55qE56CU5oql" | base64 -d > "$W/i1.txt"

TXT="$(cat "$W/t1.txt")"
INS="$(cat "$W/i1.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.2 --seed 77 --cpu --output "$OUT/01.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "01.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/01.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"


echo "== durations"
python3 - "$OUT" <<'PY'
import wave,glob,os,sys
for f in sorted(glob.glob(sys.argv[1]+'/*.wav')):
    w=wave.open(f); print(os.path.basename(f), round(w.getnframes()/w.getframerate(),2),'s', w.getframerate(),'Hz')
PY
echo ALLDONE
