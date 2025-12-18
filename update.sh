#!/usr/bin/env bash
set -x

nix flake update --flake . "$@"
nix flake update --flake ./home "$@"
