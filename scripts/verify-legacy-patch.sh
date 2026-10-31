#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE="${1:-$HOME/Downloads/youtube-webos4-cobalt-public-clean}"

PATCH="$ROOT/patches/rf1705-cobalt23/0001-webos4-acb.patch"
BASE="$(cat "$ROOT/docs/rf1705-base-commit.txt")"
COMMIT="$(cat "$ROOT/docs/webos4-patch-commit.txt")"

test -f "$PATCH"
test -d "$SOURCE/.git"

echo "=== VERIFY PROVENANCE ==="

test "$(git -C "$SOURCE" rev-parse "$COMMIT^")" = "$BASE"

git -C "$SOURCE" format-patch --stdout -1 "$COMMIT" |
  cmp - "$PATCH"

echo "PASS: Exact upstream ancestry and patch bytes"

echo "=== CREATE TEMPORARY UPSTREAM CHECKOUT ==="

TEMP="$(mktemp -d)"
WORKTREE="$TEMP/replay"
CREATED=0

cleanup() {
  if [ "$CREATED" -eq 1 ]; then
    git -C "$SOURCE" worktree remove --force "$WORKTREE" >/dev/null 2>&1 || true
  fi
  rmdir "$TEMP" 2>/dev/null || true
}
trap cleanup EXIT

git -C "$SOURCE" worktree add --quiet --detach "$WORKTREE" "$BASE"
CREATED=1

echo "=== APPLY PATCH TO ORIGINAL BASELINE ==="

git -C "$WORKTREE" apply --check "$PATCH"
git -C "$WORKTREE" apply "$PATCH"

echo "PASS: Patch applies to original RF1705 baseline"

echo "=== VERIFY PATCHED FILES BYTE-FOR-BYTE ==="

COUNT=0

while IFS= read -r file; do
  test -n "$file"

  git -C "$SOURCE" show "$COMMIT:$file" |
    cmp - "$WORKTREE/$file"

  echo "PASS: $file"
  COUNT=$((COUNT + 1))
done < <(
  git -C "$SOURCE" diff-tree \
    --no-commit-id --name-only -r "$COMMIT"
)

test "$COUNT" -eq 5

echo "=== CHECK SOURCE WHITESPACE ==="
git -C "$WORKTREE" diff --check

echo "=== VERIFY NO PERSONAL REFERENCES ==="
if grep -qi 'sophia' "$PATCH"; then
  echo "FAIL: Personal reference detected"
  exit 1
fi

echo "=== RESULT ==="
echo "PASS: All five platform files reproduced exactly"
echo "PASS: Reproducible webOS 4 Cobalt patch verified"
