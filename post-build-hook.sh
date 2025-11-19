set -eu
set -f # disable globbing

if [[ -n "${OUT_PATHS}" ]]; then
    echo "Uploading paths" $OUT_PATHS
    exec nix copy --to "http://cache.crys" $OUT_PATHS
fi
