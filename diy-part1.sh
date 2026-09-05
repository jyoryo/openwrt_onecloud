#!/usr/bin/env bash
set -Eeuo pipefail

: "${OPENCLASH_REPO:?OPENCLASH_REPO is required}"
: "${OPENCLASH_COMMIT:?OPENCLASH_COMMIT is required}"

openclash_checkout="$(mktemp -d)"
cleanup() {
  rm -rf "${openclash_checkout}"
}
trap cleanup EXIT

git -C "${openclash_checkout}" init
git -C "${openclash_checkout}" remote add origin "${OPENCLASH_REPO}"
git -C "${openclash_checkout}" config core.sparseCheckout true
printf '%s\n' 'luci-app-openclash/' > "${openclash_checkout}/.git/info/sparse-checkout"
git -C "${openclash_checkout}" fetch --depth 1 origin "${OPENCLASH_COMMIT}"
git -C "${openclash_checkout}" checkout --detach FETCH_HEAD

test "$(git -C "${openclash_checkout}" rev-parse HEAD)" = "${OPENCLASH_COMMIT}"
test -f "${openclash_checkout}/luci-app-openclash/Makefile"

rm -rf package/luci-app-openclash
cp -a "${openclash_checkout}/luci-app-openclash" package/luci-app-openclash

echo "OpenClash source: ${OPENCLASH_COMMIT}"
