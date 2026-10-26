#!/bin/bash
set -e
cd "$(dirname "$0")"
mkdir -p out
python3 fetch_indices.py
echo "--- files ---"
ls -la out/
tar czf out/indices.tgz -C out nkx.csv kospi.csv ixic.csv 2>/dev/null
ls -la out/
echo "__EXIT_CODE__=$?"
