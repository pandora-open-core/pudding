#!/bin/sh
# Install the exact requested elan release; never fall back to latest.
set -eu
repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
version=$(cat "$repo/elan-version")
case "$(uname -s)/$(uname -m)" in
    Linux/x86_64) target=x86_64-unknown-linux-gnu ;;
    Linux/aarch64) target=aarch64-unknown-linux-gnu ;;
    *) echo 'This installer supports Linux x86_64 and aarch64 only.' >&2; exit 2 ;;
esac
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
url="https://github.com/leanprover/elan/releases/download/v$version/elan-$target.tar.gz"
if ! curl --proto '=https' --tlsv1.2 --fail --location --show-error \
    --connect-timeout 15 --max-time 180 "$url" -o "$tmp/elan.tar.gz"; then
    echo "Cannot download elan $version; refusing to install another version." >&2
    exit 1
fi
expected=$(awk -v name="elan-$target.tar.gz" '$2 == name {print $1}' "$repo/elan-checksums.sha256")
[ -n "$expected" ] || { echo "Missing bootstrap checksum for $target" >&2; exit 1; }
printf '%s  %s\n' "$expected" "$tmp/elan.tar.gz" | sha256sum -c -
tar -xzf "$tmp/elan.tar.gz" -C "$tmp"
"$tmp/elan-init" -y --no-modify-path --default-toolchain none
elan_bin="${ELAN_HOME:-$HOME/.elan}/bin/elan"
actual=$("$elan_bin" --version)
case "$actual" in
    "elan $version"|"elan $version "*) printf '%s\n' "$actual" ;;
    *) echo "elan version mismatch: $actual (expected $version)" >&2; exit 1 ;;
esac
