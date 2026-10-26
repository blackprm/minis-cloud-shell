#!/bin/bash
# 在 GitHub Actions (4c/15G, 无 GPU) 上部署 HoppouAI/Breeze-TTS-2.cpp 并试跑
cd /tmp
mkdir -p out
set -x

echo "=== 环境 ===" | tee out/env.txt
nproc | tee -a out/env.txt
free -g | tee -a out/env.txt
lscpu | grep -E 'Model name|^CPU\(s\)' | tee -a out/env.txt

# --- 依赖：Vulkan loader（无 GPU 时程序会 fallback 到 CPU）---
sudo apt-get update -qq
sudo apt-get install -y -qq libvulkan1 >/dev/null 2>&1

# --- 1. 预编译包 ---
curl -sL -o b.tgz https://github.com/HoppouAI/Breeze-TTS-2.cpp/releases/download/v0.1.3/breeze-tts-2-v0.1.3-linux-x64-vulkan.tar.gz
ls -lh b.tgz
mkdir -p app && tar xzf b.tgz -C app
find app -maxdepth 3 -type f | head -40 | tee out/files.txt
BIN=$(find app -name 'breeze-cli' -type f | head -1)
echo "BIN=$BIN"
[ -z "$BIN" ] && { echo "NO BIN, abort"; exit 1; }
chmod +x $(find app -type f -name 'breeze-*')
export LD_LIBRARY_PATH="$(dirname "$BIN")${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

# --- 2. CLI 帮助 ---
"$BIN" --help > out/cli_help.txt 2>&1
cat out/cli_help.txt

# --- 3. 权重 Q8_0 3.3GB ---
time curl -sL -o m.gguf https://huggingface.co/HoppouAI/Breeze-TTS-2.cpp/resolve/main/breeze-tts-2-q8_0.gguf
ls -lh m.gguf

GEN() { # $1=输出名, 其余=参数
  local o="out/$1"; shift
  echo "##### $o" >> out/gen.log
  /usr/bin/time -v "$BIN" m.gguf "$@" --output "$o" --timings >> out/gen.log 2>&1 || \
  /usr/bin/time -v "$BIN" m.gguf "$@" --output "$o" >> out/gen.log 2>&1
  echo "exit=$? size=$(stat -c%s "$o" 2>/dev/null)" >> out/gen.log
}

# 第一枪：中文 voice design（视频里同款）
GEN 01_zh_design.wav \
  --text "论文还差三千字……让我先眯五分钟嘛。" \
  --instruction "熬夜赶论文的女大学生，困得迷迷糊糊，带鼻音，软糯" \
  --cfg-scale 4

# 中文语音事件 + 撒娇
GEN 02_zh_event.wav \
  --text "[笑] 主人，早上好呀～我是晚晚，今天也要元气满满哦！" \
  --instruction "二十岁左右的女生，声音甜美清亮，带一点慵懒和撒娇，像刚睡醒在跟你说早安" \
  --cfg-scale 4

# 同一句、三种情绪（voice design 走 instruction 控制）
GEN 03_zh_happy.wav \
  --text "哦。老板说明天不用来上班了。" \
  --instruction "知性女主播，开心到飞起，兴奋上扬" \
  --cfg-scale 4
GEN 04_zh_sad.wav \
  --text "哦。老板说明天不用来上班了。" \
  --instruction "知性女主播，委屈得快哭了，颤抖压抑" \
  --cfg-scale 4
GEN 05_zh_flat.wav \
  --text "哦。老板说明天不用来上班了。" \
  --instruction "知性女主播，语气平淡，无所谓，毫无起伏" \
  --cfg-scale 1

# 英文 + 英伦女声
GEN 06_en_design.wav \
  --text "(laugh) And yes, I speak English too." \
  --instruction "An elegant British woman in her late twenties, clear and warm, with a playful lilt." \
  --cfg-scale 4

# 中文长文本（~50s，看长句是否漂）
GEN 07_zh_long.wav \
  --text "三百年前，这里还是一片海。后来海水退去，盐碱留在了土地上，什么都种不活。第一批搬来的人用芦苇搭房，用碱土烧砖，一锹一锹把盐分冲下去。到了今天，这片土地上长出了麦子和棉花，也长出了学校、医院和一条通向城里的公路。有人说这是奇迹，其实不过是三代人，一步一步走过来的。" \
  --instruction "纪录片解说，中年男声，沉稳克制，语速偏慢" \
  --cfg-scale 4

# --- 4. 结果汇总 ---
ls -lh out/ | tee out/listing.txt
for f in out/*.wav; do
  [ -f "$f" ] && echo "$f $(ffprobe -v error -show_entries format=duration -of csv=p=0 "$f" 2>/dev/null)" >> out/durations.txt
done
cat out/durations.txt 2>/dev/null
echo ALLDONE
