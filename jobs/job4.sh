#!/bin/bash
# Breeze-TTS-2.cpp @ GitHub Actions 4c/15G, CPU only（显式 --cpu）
# 产物写到 $GITHUB_WORKSPACE/out，以便 upload-artifact 能拿到
set -x
OUT="$GITHUB_WORKSPACE/out"
mkdir -p "$OUT"
cd /tmp

BINDIR=/tmp/app/breeze-tts-2-v0.1.3-linux-x64-vulkan
if [ ! -x "$BINDIR/breeze-cli" ]; then
  curl -sL --retry 2 -m 300 -o /tmp/b.tgz https://github.com/HoppouAI/Breeze-TTS-2.cpp/releases/download/v0.1.3/breeze-tts-2-v0.1.3-linux-x64-vulkan.tar.gz
  mkdir -p /tmp/app && tar xzf /tmp/b.tgz -C /tmp/app
  chmod +x $BINDIR/breeze-*
fi
export LD_LIBRARY_PATH=$BINDIR
BIN=$BINDIR/breeze-cli

time curl -sL --retry 2 -m 1200 -o /tmp/m.gguf https://huggingface.co/HoppouAI/Breeze-TTS-2.cpp/resolve/main/breeze-tts-2-q8_0.gguf
ls -lh /tmp/m.gguf
md5sum /tmp/m.gguf | tee "$OUT/model.md5"

GEN() {
  local o="$OUT/$1"; shift
  local t0=$(date +%s)
  timeout 1500 "$BIN" /tmp/m.gguf "$@" --output "$o" --timings >> "$OUT/gen.log" 2>&1
  local rc=$?
  echo "$(basename $o) rc=$rc elapsed=$(( $(date +%s) - t0 ))s size=$(stat -c%s "$o" 2>/dev/null)" | tee -a "$OUT/summary.txt"
  # 把该条的 timings 段抽出来
  awk '/time to first audio/,/wrote/' "$OUT/gen.log" | tail -8 >> "$OUT/timings_all.txt"
  echo "----" >> "$OUT/timings_all.txt"
}

GEN 01_zh_design.wav --cpu --text "论文还差三千字……让我先眯五分钟嘛。" \
  --instruction "熬夜赶论文的女大学生，困得迷迷糊糊，带鼻音，软糯" --cfg-scale 4

GEN 02_zh_event.wav --cpu --text "[笑] 主人，早上好呀～我是晚晚，今天也要元气满满哦！" \
  --instruction "二十岁左右的女生，声音甜美清亮，带一点慵懒和撒娇，像刚睡醒在跟你说早安" --cfg-scale 4

GEN 03_zh_happy.wav --cpu --text "哦。老板说明天不用来上班了。" \
  --instruction "知性女主播，开心到飞起，兴奋上扬" --cfg-scale 4
GEN 04_zh_sad.wav --cpu --text "哦。老板说明天不用来上班了。" \
  --instruction "知性女主播，委屈得快哭了，颤抖压抑" --cfg-scale 4
GEN 05_zh_flat.wav --cpu --text "哦。老板说明天不用来上班了。" \
  --instruction "知性女主播，语气平淡，无所谓，毫无起伏" --cfg-scale 1

GEN 06_en_design.wav --cpu --text "(laugh) And yes, I speak English too." \
  --instruction "An elegant British woman in her late twenties, clear and warm, with a playful lilt." --cfg-scale 4

# 自举克隆：用上一条 AI 生成的声音 + 精确文本当参考，换台词
GEN 07_clone_self.wav --cpu --ref-audio "$OUT/01_zh_design.wav" \
  --ref-text "论文还差三千字……让我先眯五分钟嘛。" \
  --text "闹钟响了第三遍，我还是不想起床。" --cfg-scale 2

# 长文本（约 120 字，测分段与长句稳定性）
GEN 08_zh_long.wav --cpu --text "三百年前，这里还是一片海。后来海水退去，盐碱留在了土地上，什么都种不活。第一批搬来的人用芦苇搭房，用碱土烧砖，一锹一锹把盐分冲下去。到了今天，这片土地上长出了麦子和棉花，也长出了学校和一条通向城里的路。" \
  --instruction "纪录片解说，中年男声，沉稳克制，语速偏慢" --cfg-scale 4

ls -lh "$OUT" | tee "$OUT/listing.txt"
python3 - "$OUT" <<'PY'
import wave, glob, os, sys
out=sys.argv[1]
for f in sorted(glob.glob(out+'/*.wav')):
    try:
        w=wave.open(f)
        print(f"{os.path.basename(f)}  {w.getnframes()/w.getframerate():.2f}s  {w.getframerate()}Hz ch={w.getnchannels()} sw={w.getsampwidth()}")
    except Exception as e:
        print(os.path.basename(f),'BAD',e)
PY
echo ALLDONE
