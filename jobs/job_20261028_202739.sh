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

echo "== tasks: 17"

# --- 1: 01

printf %s "5Y+w56ev55S15rao5Lu3MjAl77yM5a6i5oi35o6S6Zif6K+06LCi6LCi44CC" | base64 -d > "$W/t1.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i1.txt"

TXT="$(cat "$W/t1.txt")"
INS="$(cat "$W/i1.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 42 --cpu --output "$OUT/01.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "01.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/01.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 2: 02

printf %s "IOS4jeaYr+iKr+eJh+i0te+8jOaYr+WPquacieWug+iDvemAoOOAgg==" | base64 -d > "$W/t2.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i2.txt"

TXT="$(cat "$W/t2.txt")"
INS="$(cat "$W/i2.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 43 --cpu --output "$OUT/02.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "02.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/02.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 3: 03

printf %s "IDQ2N+S6v+e+juWFg+S4gOWto++8jOWPiOaYr+WOhuWPsuacgOW8uuOAgg==" | base64 -d > "$W/t3.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i3.txt"

TXT="$(cat "$W/t3.txt")"
INS="$(cat "$W/i3.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 44 --cpu --output "$OUT/03.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "03.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/03.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 4: 04

printf %s "IOS9huecn+ato+WQk+S6uueahO+8jOS4jeaYr+i/meS7veiQpeaUtuOAgg==" | base64 -d > "$W/t4.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i4.txt"

TXT="$(cat "$W/t4.txt")"
INS="$(cat "$W/i4.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 45 --cpu --output "$OUT/04.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "04.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/04.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 5: 05

printf %s "IOaYr+S4i+Wto+W6puaMh+W8le+8muWGjea2qDU4JeOAgg==" | base64 -d > "$W/t5.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i5.txt"

TXT="$(cat "$W/t5.txt")"
INS="$(cat "$W/i5.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 46 --cpu --output "$OUT/05.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "05.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/05.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 6: 06

printf %s "IOiLseS8n+i+vuiLueaenOmrmOmAmu+8jOWFqOaYr+Wug+eahOWuouaIt+OAgg==" | base64 -d > "$W/t6.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i6.txt"

TXT="$(cat "$W/t6.txt")"
INS="$(cat "$W/i6.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 47 --cpu --output "$OUT/06.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "06.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/06.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 7: 07

printf %s "IEFJ6Iqv54mH5Y2g6JCl5pS2Njgl77yM6L+Y5Zyo5rao44CC" | base64 -d > "$W/t7.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i7.txt"

TXT="$(cat "$W/t7.txt")"
INS="$(cat "$W/i7.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 48 --cpu --output "$OUT/07.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "07.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/07.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 8: 08

printf %s "IOmtj+WTsuWutu+8mue8uuWPo+WkmuWkp++8jOaIkeS5n+S4jeefpemBk+OAgg==" | base64 -d > "$W/t8.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i8.txt"

TXT="$(cat "$W/t8.txt")"
INS="$(cat "$W/i8.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 49 --cpu --output "$OUT/08.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "08.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/08.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 9: 09

printf %s "IOS7peWJjeWuouaIt+egjeS7t+egjeWIsOeLoO+8jOeOsOWcqOS4jeegjeS6huOAgg==" | base64 -d > "$W/t9.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i9.txt"

TXT="$(cat "$W/t9.txt")"
INS="$(cat "$W/i9.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 50 --cpu --output "$OUT/09.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "09.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/09.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 10: 10

printf %s "IOS6pOacn+avlOS7t+agvOmHjeimge+8jOWFiOS4i+WNleWFiOaPkOi0p+OAgg==" | base64 -d > "$W/t10.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i10.txt"

TXT="$(cat "$W/t10.txt")"
INS="$(cat "$W/i10.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 51 --cpu --output "$OUT/10.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "10.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/10.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 11: 11

printf %s "IOS7iuW5tOWPsOenr+eUteayoei3n+iuvuWkh+WVhuiurui/h+S4gOasoeS7t+OAgg==" | base64 -d > "$W/t11.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i11.txt"

TXT="$(cat "$W/t11.txt")"
INS="$(cat "$W/i11.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 52 --cpu --output "$OUT/11.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "11.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/11.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 12: 12

printf %s "IOWFqOeQgzIw5bqn5Y6C5ZCM5pe25byA5bel77yM5Y+y5peg5YmN5L6L44CC" | base64 -d > "$W/t12.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i12.txt"

TXT="$(cat "$W/t12.txt")"
INS="$(cat "$W/i12.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 53 --cpu --output "$OUT/12.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "12.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/12.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 13: 13

printf %s "IDLnurPnsbPkuqfog73mmI7lubTnv7vlgI3vvIzov5jmmK/kuI3lpJ/jgII=" | base64 -d > "$W/t13.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i13.txt"

TXT="$(cat "$W/t13.txt")"
INS="$(cat "$W/i13.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 54 --cpu --output "$OUT/13.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "13.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/13.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 14: 14

printf %s "IOWumOaWueivtEFJ5aKe6YCf77yM5Y+v6IO96L+Y6KaB5pu06auY44CC" | base64 -d > "$W/t14.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i14.txt"

TXT="$(cat "$W/t14.txt")"
INS="$(cat "$W/i14.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 55 --cpu --output "$OUT/14.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "14.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/14.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 15: 15

printf %s "IOiuouWNleaOkua7oe+8jOS6p+iDveaKouS4jeWIsO+8jOS7t+agvOWcqOa2qOOAgg==" | base64 -d > "$W/t15.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i15.txt"

TXT="$(cat "$W/t15.txt")"
INS="$(cat "$W/i15.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 56 --cpu --output "$OUT/15.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "15.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/15.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 16: 16

printf %s "IOaZr+awlOaYr+ecn+eahO+8jDYwMOS6v+e+juWFg+aKleWFpeS5n+aYr+ecn+eahOOAgg==" | base64 -d > "$W/t16.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i16.txt"

TXT="$(cat "$W/t16.txt")"
INS="$(cat "$W/i16.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 57 --cpu --output "$OUT/16.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "16.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/16.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 17: 17

printf %s "IOi/mei9rkFJ5pmv5rCU77yM5L2g6KeJ5b6X6IO954On5Yeg5bm077yf" | base64 -d > "$W/t17.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i17.txt"

TXT="$(cat "$W/t17.txt")"
INS="$(cat "$W/i17.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 58 --cpu --output "$OUT/17.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "17.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/17.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"


echo "== durations"
python3 - "$OUT" <<'PY'
import wave,glob,os,sys
for f in sorted(glob.glob(sys.argv[1]+'/*.wav')):
    w=wave.open(f); print(os.path.basename(f), round(w.getnframes()/w.getframerate(),2),'s', w.getframerate(),'Hz')
PY
echo ALLDONE
