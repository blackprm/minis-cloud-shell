#!/bin/bash
mkdir -p out
echo "云端时间: $(date -u '+%Y-%m-%d %H:%M:%S UTC')" | tee out/env.txt
echo "CPU: $(nproc) 核 | 内存: $(free -g | awk 'NR==2{print $2}')GB" | tee -a out/env.txt
