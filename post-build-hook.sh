  set -eu
  set -f # disable globbing

  echo "Uploading paths" $OUT_PATHS
  exec nix copy --to "http://cache.crys" $OUT_PATHS
