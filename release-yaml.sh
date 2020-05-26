#!/usr/bin/env bash

set -ueo pipefail

root_d="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"
bin_d="${root_d}/bin"

latest_tag="$(git tag -l | sort -V | tail -r | head -n 1)"

echo "Latest tag is ${latest_tag}"
echo "---"
echo "binaries:"

versions=(
cf-conduit.darwin.amd64
cf-conduit.windows.386
cf-conduit.windows.amd64
cf-conduit.linux.386
cf-conduit.linux.amd64
)

for v in "${versions[@]}"; do
  url="https://github.com/alphagov/paas-cf-conduit/releases/download/${latest_tag}/${v}"
  checksum="$(curl -sfL "${url}.sha1")"

cat <<EOF
- checksum: ${checksum}
  platform: $(grep -o 'windows\|darwin\|linux' <<< "$v")
  url: ${url}
EOF

done