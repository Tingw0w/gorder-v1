#!/usr/bin/env bash

set -euo pipefail

shopt -s globstar

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    SEP="\\\\"
else
    SEP="/"
fi

if ! [[ "$0" =~ scripts${SEP}genopenapi.sh ]]; then
  echo "must be run from repository root"
  exit 255
fi

source .${SEP}scripts${SEP}lib.sh
OPENAPI_ROOT=".${SEP}api${SEP}openapi"

GEN_SERVER=(
#  "chi-server"
#  "echo-server"
  "gin-server"
)

if [ "${#GEN_SERVER[@]}" -ne 1 ]; then
  log_error "GEN_SERVER enables more than 1 server, please check."
  exit 255
fi

log_callout "Using $GEN_SERVER"

function openapi_files {
  openapi_files=$(ls ${OPENAPI_ROOT})
  echo "${openapi_files[@]}"
}

function gen() {
  local output_dir=$1
  local package=$2
  local service=$3

  run mkdir -p "${output_dir}"
  run find "${output_dir}" -type f -name "*.gen.go" -delete

  prepare_dir "internal${SEP}common${SEP}client${SEP}$service"

  run oapi-codegen -generate types -o "$output_dir${SEP}openapi_types.gen.go" -package "$package" "api${SEP}openapi${SEP}$service.yml"
  run oapi-codegen -generate "$GEN_SERVER" -o "$output_dir${SEP}openapi_api.gen.go" -package "$package" "api${SEP}openapi${SEP}$service.yml"

  run oapi-codegen -generate types -o "internal${SEP}common${SEP}client${SEP}$service${SEP}openapi_types.gen.go" -package "$service" "api${SEP}openapi${SEP}$service.yml"
  run oapi-codegen -generate client -o "internal${SEP}common${SEP}client${SEP}$service${SEP}openapi_client_gen.go" -package "$service" "api${SEP}openapi${SEP}$service.yml"
}

gen internal${SEP}order${SEP}ports ports order
