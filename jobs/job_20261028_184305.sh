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

printf %s "5Y+w56ev55S15rao5Lu3MjAl77yM5a6i5oi35o6S6Zif6K+06LCi6LCi44CC5LiN5piv6Iqv54mH6LS177yM5piv5Y+q5pyJ5a6D6IO96YCg44CCNDY35Lq/576O5YWD5LiA5a2j77yM5Y+I5piv5Y6G5Y+y5pyA5by644CC" | base64 -d > "$W/t1.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i1.txt"

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
