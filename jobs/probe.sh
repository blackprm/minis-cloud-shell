#!/bin/bash
set -x
time (if ! command -v ffmpeg; then sudo apt-get update -qq && sudo apt-get install -y -qq ffmpeg; fi)
ffmpeg -version | head -2
mkdir -p "$ROOT/out"
echo ok > "$ROOT/out/probe.txt"
