#!/bin/bash
# Breeze-TTS-2.cpp：直接用官方 Linux 预编译包试跑（上次 --help 误判）
set -x
mkdir -p /tmp/out
cd /tmp

BINDIR=/tmp/app/breeze-tts-2-v0.1.3-linux-x64-vulkan
curl -sL --retry 2 -m 300 -o /tmp/b.tgz https://github.com/HoppouAI/Breeze-TTS-2.cpp/releases/download/v0.1.3/breeze-tts-2-v0.1.3-linux-x64-vulkan.tar.gz
mkdir -p /tmp/app && tar xzf /tmp/b.tgz -C /tmp/app
chmod +x $BINDIR/breeze-* 2>/dev/null
export LD_LIBRARY_PATH=$BINDIR
cp $BINDIR/docs/cli.md /tmp/out/cli_doc.md
echo "--- CLI DOC ---"
head -80 /tmp/out/cli_doc.md

BIN=$BINDIR/breeze-cli
"$BIN" --version 2>&1 | head -3
echo "no-arg:"; "$BIN" 2>&1 | head -5

# 权重
time curl -sL --retry 2 -m 1200 -o /tmp/m.gguf https://huggingface.co/HoppouAI/Breeze-TTS-2.cpp/resolve/main/breeze-tts-2-q8_0.gguf
ls -lh /tmp/m.gguf

GEN() {
  local o="/tmp/out/$1"; shift
  echo "##### $o  $(date +%H:%M:%S)" >> /tmp/out/gen.log
  local t0=$(date +%s)
  timeout 1200 "$BIN" /tmp/m.gguf "$@" --output "$o" --timings >> /tmp/out/gen.log 2>&1
  local rc=$?
  echo "rc=$rc elapsed=$(( $(date +%s) - t0 ))s size=$(stat -c%s "$o" 2>/dev/null)" >> /tmp/out/gen.log
  tail -6 /tmp/out/gen.log
}

# 0) 探针：最短的一条，验证参数与后端
GEN 00_probe.wav --text "你好。" --instruction "年轻女性，声音清晰" --cfg-scale 4

if [ -s /tmp/out/00_probe.wav ]; then
  GEN 01_zh_design.wav --text "论文还差三千字……让我先眯五分钟嘛。" \
    --instruction "熬夜赶论文的女大学生，困得迷迷糊糊，带鼻音，软糯" --cfg-scale 4
  GEN 02_zh_event.wav --text "[笑] 主人，早上好呀～我是晚晚，今天也要元气满满哦！" \
    --instruction "二十岁左右的女生，声音甜美清亮，带一点慵懒和撒娇，像刚睡醒在跟你说早安" --cfg-scale 4
  GEN 03_zh_happy.wav --text "哦。老板说明天不用来上班了。" \
    --instruction "知性女主播，开心到飞起，兴奋上扬" --cfg-scale 4
  GEN 04_zh_sad.wav --text "哦。老板说明天不用来上班了。" \
    --instruction "知性女主播，委屈得快哭了，颤抖压抑" --cfg-scale 4
  GEN 05_zh_flat.wav --text "哦。老板说明天不用来上班了。" \
    --instruction "知性女主播，语气平淡，无所谓，毫无起伏" --cfg-scale 1
  GEN 06_en_design.wav --text "(laugh) And yes, I speak English too." \
    --instruction "An elegant British woman in her late twenties, clear and warm, with a playful lilt." --cfg-scale 4
else
  echo "PROBE FAILED, see gen.log"
fi

ls -lh /tmp/out/ | tee /tmp/out/listing.txt
python3 - <<'PY' | tee /tmp/out/durations.txt
import wave, glob, os
for f in sorted(glob.glob('/tmp/out/*.wav')):
    try:
        w = wave.open(f)
        print(f"{os.path.basename(f)}  {w.getnframes()/w.getframerate():.2f}s  {w.getframerate()}Hz  ch={w.getnchannels()}  sw={w.getsampwidth()}")
    except Exception as e:
        print(f"{os.path.basename(f)}  BAD {e}")
PY
echo ALLDONE
