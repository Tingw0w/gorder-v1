#!/usr/bin/env bash

set -euo pipefail

#**
shopt -s globstar

if ! [[ "$0" =~ scripts/genproto.sh ]]; then
  echo "mush be run from repository root"
  exit 255
fi

source ./scripts/lib.sh
API_ROOT="./api"

function dirs {
  dirs=()
  while IFS= read -r dir; do
    dirs+=("$dir")
  done < <(find . -type f -name "*.proto" -exec dirname {} \; | xargs -n1 basename | sort -u)
  echo "${dirs[@]}"
}