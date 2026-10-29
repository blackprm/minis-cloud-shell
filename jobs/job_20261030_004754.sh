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

echo "== tasks: 18"

# --- 1: 01

printf %s "5pio5pma77yM6LC35q2M6LeM5LqGIDEyJeOAgg==" | base64 -d > "$W/t1.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i1.txt"

TXT="$(cat "$W/t1.txt")"
INS="$(cat "$W/i1.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 42 --cpu --output "$OUT/01.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "01.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/01.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 2: 02

printf %s "IDIyIOW5tOmHjO+8jOWug+WPqui3jOi/h+S4pOasoSAxMCUg5Lul5LiK44CC" | base64 -d > "$W/t2.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i2.txt"

TXT="$(cat "$W/t2.txt")"
INS="$(cat "$W/i2.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 43 --cpu --output "$OUT/02.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "02.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/02.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 3: 03

printf %s "IOWJjeS4pOasoeaYr+WFqOeQg+WNseacuu+8jOi/meS4gOasoeaYr+Wug+iHquW3seeahOi0ouaKpeOAgg==" | base64 -d > "$W/t3.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i3.txt"

TXT="$(cat "$W/t3.txt")"
INS="$(cat "$W/i3.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 44 --cpu --output "$OUT/03.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "03.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/03.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 4: 04

printf %s "IOaUtuWFpeWkmui1muS6hiA3OCDkur/vvIzokKXkuJrliKnmtqblsJHkuoYgMiDkur/jgII=" | base64 -d > "$W/t4.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i4.txt"

TXT="$(cat "$W/t4.txt")"
INS="$(cat "$W/i4.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 45 --cpu --output "$OUT/04.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "04.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/04.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 5: 05

printf %s "IOaUtuWFpeWIm+aWsOmrmO+8jOWIqea2puWNtOWcqOe8qeawtOOAgg==" | base64 -d > "$W/t5.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i5.txt"

TXT="$(cat "$W/t5.txt")"
INS="$(cat "$W/i5.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 46 --cpu --output "$OUT/05.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "05.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/05.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 6: 06

printf %s "IOWug+aKiuWbm+aIkOaUtuWFpe+8jOaLv+WOu+S5sOS6hueul+WKm+OAgg==" | base64 -d > "$W/t6.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i6.txt"

TXT="$(cat "$W/t6.txt")"
INS="$(cat "$W/i6.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 47 --cpu --output "$OUT/06.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "06.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/06.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 7: 07

printf %s "IOaQnOe0ouW5v+WRiu+8jOS4gOS4quWto+W6puWPquWkmuS6hiA3OTAwIOS4h+e+juWFg+OAgg==" | base64 -d > "$W/t7.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i7.txt"

TXT="$(cat "$W/t7.txt")"
INS="$(cat "$W/i7.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 48 --cpu --output "$OUT/07.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "07.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/07.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 8: 08

printf %s "IOaQnOe0oumHj+aYr+S6lOW5tOacgOmrmO+8jOWNtOWHoOS5juS4jeWkmui1mumSseOAgg==" | base64 -d > "$W/t8.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i8.txt"

TXT="$(cat "$W/t8.txt")"
INS="$(cat "$W/i8.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 49 --cpu --output "$OUT/08.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "08.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/08.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 9: 09

printf %s "IOavj+S4quWto+W6pu+8jOi/mSA3OCDkur/mmK/osIHotKHnjK7nmoTvvJ8=" | base64 -d > "$W/t9.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i9.txt"

TXT="$(cat "$W/t9.txt")"
INS="$(cat "$W/i9.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 50 --cpu --output "$OUT/09.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "09.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/09.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 10: 10

printf %s "IOS6keS4muWKoee/u+WAje+8jOS4gOW5tOS7jiAxNTAg5Lq/5rao5YiwIDMwNyDkur/jgII=" | base64 -d > "$W/t10.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i10.txt"

TXT="$(cat "$W/t10.txt")"
INS="$(cat "$W/i10.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 51 --cpu --output "$OUT/10.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "10.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/10.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 11: 11

printf %s "IOWQjOS4gOWdl+iKr+eJh++8jOiHquW3seeUqOaYr+aKmOaXp++8jOWNluaOieaYr+WtmOi0p+OAgg==" | base64 -d > "$W/t11.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i11.txt"

TXT="$(cat "$W/t11.txt")"
INS="$(cat "$W/i11.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 52 --cpu --output "$OUT/11.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "11.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/11.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 12: 12

printf %s "IOWtmOi0p+S7jiAyNCDkur/mtqjliLAgMTMzIOS6v++8jOS6lOWAjeWkmuOAgg==" | base64 -d > "$W/t12.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i12.txt"

TXT="$(cat "$W/t12.txt")"
INS="$(cat "$W/i12.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 53 --cpu --output "$OUT/12.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "12.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/12.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 13: 13

printf %s "IOmXruS6huS4ieasoe+8jOS4gOasoeaVsOWtl+mDveayoee7meOAgg==" | base64 -d > "$W/t13.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i13.txt"

TXT="$(cat "$W/t13.txt")"
INS="$(cat "$W/i13.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 54 --cpu --output "$OUT/13.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "13.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/13.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 14: 14

printf %s "IOiwt+atjOiKseW+l+Wkmu+8jOW+rui9r+S5n+iKseW+l+Wkmu+8jOe7k+WxgOebuOWPjeOAgg==" | base64 -d > "$W/t14.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i14.txt"

TXT="$(cat "$W/t14.txt")"
INS="$(cat "$W/i14.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 55 --cpu --output "$OUT/14.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "14.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/14.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 15: 15

printf %s "IOWOhuWPsuS4iui3jOWujO+8jOW5s+WdhyA2MSDlpKnlm57mnKzjgII=" | base64 -d > "$W/t15.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i15.txt"

TXT="$(cat "$W/t15.txt")"
INS="$(cat "$W/i15.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 56 --cpu --output "$OUT/15.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "15.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/15.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 16: 16

printf %s "IOiDveS4jeiDveWbnuacrO+8jOWPluWGs+S6jueUn+aEj++8jOS4jeWPluWGs+S6juiCoeS7t+OAgg==" | base64 -d > "$W/t16.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i16.txt"

TXT="$(cat "$W/t16.txt")"
INS="$(cat "$W/i16.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 57 --cpu --output "$OUT/16.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "16.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/16.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 17: 17

printf %s "IDEg5pyI5bqV55uv5LiJ5Lu25LqL77ya5pCc57Si546v5q+U44CB5LqR5YmU6ZmkIFRQVeOAgTIwMjcg6LWE5pys5byA5pSv44CC" | base64 -d > "$W/t17.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i17.txt"

TXT="$(cat "$W/t17.txt")"
INS="$(cat "$W/i17.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 58 --cpu --output "$OUT/17.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "17.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/17.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"

# --- 18: 18

printf %s "IOaLv+WIsOaVsOaNru+8jOWGjeWGs+WumuimgeS4jeimgeaFjOOAgg==" | base64 -d > "$W/t18.txt"

printf %s "5LiJ5Y2B5LqM5bKB55S35oCn77yM6IO46IWU5YWx6bij5by677yM5aOw6Z+z5rWR5Y6a5YGP5L2O55qE55+t6KeG6aKR6Kej6K+06IWU77yM5ZCQ5a2X5p6B5b+r5L2G6aKX57KS5YiG5piO77yM5YWz6ZSu5pWw5a2X5ZKM57uT6K666K+N6YeN6K+777yM5Y+l5a2Q5LmL6Ze05Yeg5LmO5LiN55WZ5rCU5Y+j77yM5YOP5paw6Ze75b+r6K6v5Li75pKt6YGH5LiK55S15b2x6Kej6K+0" | base64 -d > "$W/i18.txt"

TXT="$(cat "$W/t18.txt")"
INS="$(cat "$W/i18.txt")"

START=$(date +%s)
"$BIN" m.gguf --text "$TXT" --instruction "$INS" --cfg-scale 4.0 --seed 59 --cpu --output "$OUT/18.wav" --timings 2>&1 | tee -a "$OUT/gen.log"

echo "18.wav rc=${PIPESTATUS[0]} elapsed=$(( $(date +%s) - START ))s size=$(stat -c%s "$OUT/18.wav" 2>/dev/null)" | tee -a "$OUT/summary.txt"


echo "== durations"
python3 - "$OUT" <<'PY'
import wave,glob,os,sys
for f in sorted(glob.glob(sys.argv[1]+'/*.wav')):
    w=wave.open(f); print(os.path.basename(f), round(w.getnframes()/w.getframerate(),2),'s', w.getframerate(),'Hz')
PY
echo ALLDONE
