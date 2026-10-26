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

echo "== tasks: 4"

# --- 1: A研报男

printf %s "5aaC5p6c5L2g5ZyoMTk5MeW5tO+8jOaKiuS4gOS4h+Wdl+aKlei/m+i/meWbm+S4quW4guWcuu+8jOS7iuWkqeS8muWPmOaIkOWkmuWwke+8n+S4nOS6rOWFq+S4h++8jOmmluWwlOS6jOWNgeWFq+S4h++8jOe6vee6puS6lOWNgeS4h++8jOS4iua1t+Wbm+WNgeS5neS4h+OAgg==" | base64 -d > "$W/t1.txt"

printf %s "5LiJ5Y2B5LqU5bKB55S35oCn77yM5Lit5L2O6Z+z77yM6IO46IWU5YWx6bij5omO5a6e77yM6K+t6YCf5Lit5YGP5b+r77yM6K+t5rCU5YWL5Yi25Yeg5LmO5LiN5bim5oOF57uq77yM5Y+l5bC+5bmy6ISG5LiL5rKJ77yM5YOP5Zyo5b+15LiA5Lu95LiN5a65572u55aR55qE56CU5oql" | base64 -d > "$W/i1.txt"

TXT="$(cat "$W/t1.txt")"
INS="$(cat "$W/i1.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 41 --cpu --output "$OUT/01_A研报男.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "01_A研报男.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/01_A研报男.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 2: B财经女

printf %s "5aaC5p6c5L2g5ZyoMTk5MeW5tO+8jOaKiuS4gOS4h+Wdl+aKlei/m+i/meWbm+S4quW4guWcuu+8jOS7iuWkqeS8muWPmOaIkOWkmuWwke+8n+S4nOS6rOWFq+S4h++8jOmmluWwlOS6jOWNgeWFq+S4h++8jOe6vee6puS6lOWNgeS4h++8jOS4iua1t+Wbm+WNgeS5neS4h+OAgg==" | base64 -d > "$W/t2.txt"

printf %s "5LiJ5Y2B5bKB5aWz5oCn77yM5aOw6Z+z5riF5Lqu5YGP5Lit5oCn77yM5pKt6Z+z6IWU5L2G5LiN56uv552A77yM6K+t6YCf5Yip6JC977yM5pWw5a2X5ZKs5b6X54m55Yir5riF5qWa77yM5Y+l5bC+5bim5LiA54K56ZSL5Yip55qE5pS25p2f" | base64 -d > "$W/i2.txt"

TXT="$(cat "$W/t2.txt")"
INS="$(cat "$W/i2.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 42 --cpu --output "$OUT/02_B财经女.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "02_B财经女.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/02_B财经女.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 3: C纪录片

printf %s "5aaC5p6c5L2g5ZyoMTk5MeW5tO+8jOaKiuS4gOS4h+Wdl+aKlei/m+i/meWbm+S4quW4guWcuu+8jOS7iuWkqeS8muWPmOaIkOWkmuWwke+8n+S4nOS6rOWFq+S4h++8jOmmluWwlOS6jOWNgeWFq+S4h++8jOe6vee6puS6lOWNgeS4h++8jOS4iua1t+Wbm+WNgeS5neS4h+OAgg==" | base64 -d > "$W/t3.txt"

printf %s "5Zub5Y2B5LqU5bKB55S35oCn77yM5L2O5rKJ5a695Y6a77yM5rCU5Y+j5rex77yM6K+t6YCf5oWi6ICM56iz77yM5pWw5a2X5LmL6Ze055WZ55m977yM5pyJ5p2D5aiB5oSf5ZKM5LiA54K55rKn5qGR" | base64 -d > "$W/i3.txt"

TXT="$(cat "$W/t3.txt")"
INS="$(cat "$W/i3.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 43 --cpu --output "$OUT/03_C纪录片.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "03_C纪录片.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/03_C纪录片.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 4: D科技男

printf %s "5aaC5p6c5L2g5ZyoMTk5MeW5tO+8jOaKiuS4gOS4h+Wdl+aKlei/m+i/meWbm+S4quW4guWcuu+8jOS7iuWkqeS8muWPmOaIkOWkmuWwke+8n+S4nOS6rOWFq+S4h++8jOmmluWwlOS6jOWNgeWFq+S4h++8jOe6vee6puS6lOWNgeS4h++8jOS4iua1t+Wbm+WNgeS5neS4h+OAgg==" | base64 -d > "$W/t4.txt"

printf %s "5LqM5Y2B5YWr5bKB55S35oCn77yM5bmy5YeA5piO5Lqu55qE5Lit6Z+z77yM6K+t6YCf5b+r5pyJ6IqC5aWP77yM5YWz6ZSu5pWw5a2X5Lya5Yqg6YeN77yM5bim5LiA54K55YWL5Yi255qE5YW05aWL77yM5LiN5rK56IW7" | base64 -d > "$W/i4.txt"

TXT="$(cat "$W/t4.txt")"
INS="$(cat "$W/i4.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 44 --cpu --output "$OUT/04_D科技男.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "04_D科技男.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/04_D科技男.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"


echo "== durations"
python3 - "$OUT" <<'PY'
import wave,glob,os,sys
for f in sorted(glob.glob(sys.argv[1]+'/*.wav')):
    w=wave.open(f); print(os.path.basename(f), round(w.getnframes()/w.getframerate(),2),'s', w.getframerate(),'Hz')
PY
echo ALLDONE
