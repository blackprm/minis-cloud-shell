#!/bin/bash
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ROOT/out" proj
cd proj
base64 -d > p.tgz <<'B64END'
H4sIAM623moC/+3BAQ0AAADCoPdPbQ43oAAAAAAAAAAAAIA3A5reHScAKAAA
B64END
tar xzf p.tgz
rm -f p.tgz
bash job.sh

ls -la "$ROOT/out"
