#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
E="C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"
SRC="file:///$(cygpath -m "$PWD/icon.html")"
for spec in "512 icon-512.png" "192 icon-192.png" "180 apple-touch-icon.png"; do
  set -- $spec
  "$E" --headless=new --disable-gpu --no-first-run --hide-scrollbars --window-size=$1,$1 --screenshot="$(cygpath -m "$PWD/$2")" "$SRC" 2>/dev/null
  echo "$2: $(stat -c %s "$2") Bytes"
done
