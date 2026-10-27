ROOT="$GITHUB_WORKSPACE"
mkdir -p "$ROOT/out"
head -c 1200000 /dev/urandom > "$ROOT/out/asset.mp4"
ls -l "$ROOT/out"
