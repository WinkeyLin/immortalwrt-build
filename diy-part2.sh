#!/usr/bin/env bash

# This script runs after feeds are installed.
# It adjusts the default theme and optionally downloads third-party IPK files.

set -euo pipefail

root_dir="${1:-$PWD}"
theme_file="${root_dir}/feeds/luci/collections/luci-light/Makefile"
config_file="${root_dir}/feeds/luci/modules/luci-base/root/etc/config/luci"
ipk_dir="${GITHUB_WORKSPACE:-$root_dir}/prebuilt-ipk"
ipk_list=(
  "https://nya.globalslb.net/natfrp/client/launcher-openwrt/3.1.7/luci-app-natfrp_amd64.ipk"
  "https://github.com/ttc0419/uuplugin/releases/download/latest/uuplugin_latest-1_x86_64.ipk"
)

download_ipk() {
  local url="$1"
  local file_name=""

  file_name="$(basename "${url%%\?*}")"
  test -n "$file_name" || {
    echo "Cannot derive the IPK file name from URL: $url" >&2
    exit 1
  }

  curl --fail --location --retry 3 --retry-all-errors \
    --output "${ipk_dir}/${file_name}" "$url"
}

test -f "$theme_file" || {
  echo "Theme Makefile is missing." >&2
  exit 1
}

test -f "$config_file" || {
  echo "LuCI config file is missing." >&2
  exit 1
}

sed -i 's/+luci-theme-bootstrap/+luci-theme-argon/g' "$theme_file"
sed -i 's|/luci-static/bootstrap|/luci-static/argon|g' "$config_file"

mkdir -p "$ipk_dir"

for url in "${ipk_list[@]}"; do
  download_ipk "$url"
done

if test -n "${IPK_URLS:-}"; then
  while IFS= read -r url; do
    test -n "$url" || continue
    download_ipk "$url"
  done < <(printf '%s\n' "$IPK_URLS" | tr ', ' '\n\n' | sed '/^$/d')
fi
