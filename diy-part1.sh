#!/usr/bin/env bash

# This script runs before feeds are updated.
# It pins third-party feed sources to the top and can be extended for extra packages.

set -euo pipefail

root_dir="${1:-$PWD}"
feeds_file="${root_dir}/feeds.conf.default"
tmp_file="$(mktemp)"

write_feed() {
  local name="$1"
  local url="$2"

  printf "src-git %s %s\n" "$name" "$url"
}

test -f "$feeds_file" || {
  echo "feeds.conf.default is missing." >&2
  exit 1
}

grep -Ev '^src-git[[:space:]]+(kenzo|small|helloworld)[[:space:]]+' "$feeds_file" > "$tmp_file" || true

{
  write_feed "kenzo" "https://github.com/kenzok8/openwrt-packages"
  write_feed "small" "https://github.com/kenzok8/small"
  write_feed "helloworld" "https://github.com/fw876/helloworld"
  printf "\n"
  cat "$tmp_file"
} > "$feeds_file"

rm -f "$tmp_file"
