#!/usr/bin/env bash
# Compare NixOS system derivations between old (pre-refactor) and new (refactored) flake
# using nix-diff to verify no functional changes.
#
# Usage: ./diff.sh [configuration-name]
#   If no configuration name is given, all NixOS configurations are compared.
#
# Prerequisites: nix (with flakes), nix-diff
#   Install nix-diff: nix profile install nixpkgs#nix-diff
#
# The script evaluates derivation paths for each NixOS configuration from both
# the main branch and the current HEAD, then uses nix-diff to show any differences.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_ROOT"

OLD_REV=$(git rev-parse main)
NEW_REV=$(git rev-parse HEAD)

CONFIGS=("cwystaws-meowchine" "cwystaws-raspi" "cwystaws-dormpi")

if [[ $# -ge 1 ]]; then
  CONFIGS=("$1")
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BOLD}Comparing NixOS configurations${NC}"
echo -e "  old: ${OLD_REV} (main)"
echo -e "  new: ${NEW_REV} (HEAD)"
echo ""

# Create a temporary worktree for the old revision
OLD_WORKTREE=$(mktemp -d)
used_worktree=false

if git worktree add --quiet "$OLD_WORKTREE" "$OLD_REV" 2>/dev/null; then
  used_worktree=true
else
  # If worktree fails (e.g. shallow clone), fall back to a temp copy
  echo -e "${YELLOW}Worktree creation failed, falling back to temp copy...${NC}"
  rm -rf "$OLD_WORKTREE"
  OLD_WORKTREE=$(mktemp -d)
  git archive "$OLD_REV" | tar -x -C "$OLD_WORKTREE"
fi

cleanup() {
  if $used_worktree; then
    git worktree remove --force "$OLD_WORKTREE" 2>/dev/null || true
  fi
  rm -rf "$OLD_WORKTREE"
}
trap cleanup EXIT

has_diffs=0

for config in "${CONFIGS[@]}"; do
  echo -e "${YELLOW}==> nixosConfigurations.${config}${NC}"

  echo -n "  Evaluating old... "
  old_drv=$(nix eval "path:${OLD_WORKTREE}#nixosConfigurations.${config}.config.system.build.toplevel.drvPath" --raw 2>&1) || {
    echo -e "${RED}FAILED${NC}"
    echo "    $old_drv"
    has_diffs=1
    continue
  }
  echo "$old_drv"

  echo -n "  Evaluating new... "
  new_drv=$(nix eval "path:${REPO_ROOT}#nixosConfigurations.${config}.config.system.build.toplevel.drvPath" --raw 2>&1) || {
    echo -e "${RED}FAILED${NC}"
    echo "    $new_drv"
    has_diffs=1
    continue
  }
  echo "$new_drv"

  if [[ "$old_drv" == "$new_drv" ]]; then
    echo -e "  ${GREEN}✓ Identical${NC}"
  else
    echo -e "  ${RED}✗ Derivations differ${NC}"
    echo ""
    nix-diff "$old_drv" "$new_drv" || true
    echo ""
    has_diffs=1
  fi

  echo ""
done

if [[ $has_diffs -eq 0 ]]; then
  echo -e "${GREEN}${BOLD}All configurations produce identical derivations!${NC}"
else
  echo -e "${RED}${BOLD}Some configurations differ. See output above.${NC}"
fi

exit $has_diffs
