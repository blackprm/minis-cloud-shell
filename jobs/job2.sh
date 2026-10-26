#!/bin/bash
# Breeze-TTS-2.cpp 部署试跑（无 GPU / 跳过 apt-deps）
cd /tmp
mkdir -p out
set -x

{
  echo "=== 环境 ==="; nproc; free -g | head -2; df -h / | tail -1
  lscpu | grep -E 'Model name|^CPU\(s\)'
  g++ --version | head -1; cmake --version | head -1
} | tee out/env.txt

# ---------- 1. 先试预编译包 ----------
curl -sL --retry 2 -m 300 -o b.tgz https://github.com/HoppouAI/Breeze-TTS-2.cpp/releases/download/v0.1.3/breeze-tts-2-v0.1.3-linux-x64-vulkan.tar.gz
ls -lh b.tgz
mkdir -p app && tar xzf b.tgz -C app
find app -maxdepth 3 -type f | head -30 | tee out/files.txt
BIN=$(find app -name 'breeze-cli' -type f | head -1)
chmod +x $(find app -type f -name 'breeze-*') 2>/dev/null
export LD_LIBRARY_PATH="$(dirname "$BIN")${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
ldd "$BIN" 2>&1 | grep -i vulkan | tee out/ldd_vulkan.txt

OK=0
if [ -n "$BIN" ]; then
  timeout 60 "$BIN" --help > out/cli_help_prebuilt.txt 2>&1 && OK=1
  echo "prebuilt help exit=$? ok=$OK"
  head -30 out/cli_help_prebuilt.txt
fi

# libvulkan1 尝试（给 150 秒预算，失败就算了 → 走编译）
if [ "$OK" = "0" ]; then
  timeout 150 sudo apt-get install -y -qq -o Acquire::http::Timeout=15 libvulkan1 > out/apt.log 2>&1 \
    || timeout 150 sudo apt-get install -y -qq libvulkan1 >> out/apt.log 2>&1
  ldconfig 2>/dev/null
  if [ -n "$BIN" ]; then
    timeout 60 "$BIN" --help > out/cli_help_prebuilt.txt 2>&1 && OK=1
    echo "after libvulkan: ok=$OK"
  fi
fi

# ---------- 2. 兜底：源码 CPU-only 编译 ----------
if [ "$OK" = "0" ]; then
  echo "===== fallback: 源码编译 CPU-only =====" | tee out/build.log
  export GIT_TERMINAL_PROMPT=0
  time git clone --depth 1 --recursive -q https://github.com/HoppouAI/Breeze-TTS-2.cpp src 2>&1 | tee -a out/build.log
  cd src || exit 1
  ( time cmake -B build -DCMAKE_BUILD_TYPE=Release -DBREEZE_VULKAN=OFF -DCMAKE_CXX_FLAGS="-O2" ) >> out/build.log 2>&1
  ( time cmake --build build -j4 ) >> out/build.log 2>&1
  tail -20 out/build.log
  BIN=/tmp/src/build/breeze-cli
  cd /tmp
  [ -x "$BIN" ] && OK=1
fi

echo "FINAL BIN=$BIN OK=$OK"
[ "$OK" = "1" ] || { echo "BUILD FAILED"; tail -50 out/build.log 2>/dev/null; exit 1; }

"$BIN" --help > out/cli_help.txt 2>&1
cat out/cli_help.txt

# ---------- 3. 权重 ----------
time curl -sL --retry 2 -m 900 -o m.gguf https://huggingface.co/HoppouAI/Breeze-TTS-2.cpp/resolve/main/breeze-tts-2-q8_0.gguf
ls -lh m.gguf

TIMING="--timings"
rg -q 'timings' out/cli_help.txt 2>/dev/null || grep -q 'timings' out/cli_help.txt || TIMING=""

GEN() {
  local o="out/$1"; shift
  echo "##### $o  $(date +%H:%M:%S)" >> out/gen.log
  local t0=$(date +%s)
  timeout 900 "$BIN" m.gguf "$@" --output "$o" $TIMING >> out/gen.log 2>&1
  local rc=$?
  echo "rc=$rc elapsed=$(( $(date +%s) - t0 ))s size=$(stat -c%s "$o" 2>/dev/null)" >> out/gen.log
}

GEN 01_zh_design.wav \
  --text "论文还差三千字……让我先眯五分钟嘛。" \
  --instruction "熬夜赶论文的女大学生，困得迷迷糊糊，带鼻音，软糯" \
  --cfg-scale 4

GEN 02_zh_event.wav \
  --text "[笑] 主人，早上好呀～我是晚晚，今天也要元气满满哦！" \
  --instruction "二十岁左右的女生，声音甜美清亮，带一点慵懒和撒娇，像刚睡醒在跟你说早安" \
  --cfg-scale 4

GEN 03_zh_happy.wav \
  --text "哦。老板说明天不用来上班了。" \
  --instruction "知性女主播，开心到飞起，兴奋上扬" --cfg-scale 4
GEN 04_zh_sad.wav \
  --text "哦。老板说明天不用来上班了。" \
  --instruction "知性女主播，委屈得快哭了，颤抖压抑" --cfg-scale 4
GEN 05_zh_flat.wav \
  --text "哦。老板说明天不用来上班了。" \
  --instruction "知性女主播，语气平淡，无所谓，毫无起伏" --cfg-scale 1

GEN 06_en_design.wav \
  --text "(laugh) And yes, I speak English too." \
  --instruction "An elegant British woman in her late twenties, clear and warm, with a playful lilt." \
  --cfg-scale 4

# ---------- 4. 汇总 ----------
ls -lh out/ | tee out/listing.txt
python3 - <<'PY' | tee out/durations.txt
import wave, glob, os
for f in sorted(glob.glob('/tmp/out/*.wav')):
    try:
        w = wave.open(f)
        print(f"{os.path.basename(f)}  {w.getnframes()/w.getframerate():.2f}s  {w.getframerate()}Hz  ch={w.getnchannels()}  sw={w.getsampwidth()}")
    except Exception as e:
        print(f"{os.path.basename(f)}  BAD {e}")
PY
echo ALLDONE
