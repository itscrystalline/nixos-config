set -eu
set -f

if [ -n "$OUT_PATHS" ]; then
  echo "Uploading paths" $OUT_PATHS
  nix copy --to "http://cache.crys" $OUT_PATHS
fi
