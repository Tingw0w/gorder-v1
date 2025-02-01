#!/usr/bin/env bash

set -euo pipefail

# enables globstar, using `**`.
shopt -s globstar

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    SEP="\\\\"
else
    SEP="/"
fi

dir="scripts"
file="genproto.sh"
libFile="lib.sh"
api="api"

# 拼接路径
path="${dir}${SEP}${file}"
libPath=".${SEP}${dir}${SEP}${libFile}"
apiPath=".${SEP}${api}"

## 输出路径
#echo "Generated path: $path"
#echo "Generated path2: $libPath"
#
## 示例：使用路径
#if [[ -e "$apiPath" ]]; then
#    echo "File exists: $apiPath"
#else
#    echo "File does not exist: $apiPath"
#fi

if ! [[ "$0" =~ $path ]]; then
  echo "mush be run from repository root"
  exit 255
fi


source .${SEP}scripts${SEP}lib.sh
API_ROOT=$apiPath

function dirs {
  dirs=()
  while IFS= read -r dir; do
    dirs+=("$dir")
  done < <(find . -type f -name "*.proto" -exec dirname {} \; | xargs -n1 basename | sort -u)
  echo "${dirs[@]}"
}


function pb_files {
  pb_files=$(find . -type f -name "*.proto")
  echo "${pb_files[@]}"
}

function gen_for_modules() {
  local go_out="internal${SEP}common${SEP}genproto"
  if [ -d "$go_out" ]; then
    log_warning "found existing $go_out, cleaning all files under it"
    run rm -rf $go_out
  fi

  for dir in $(dirs); do
    echo "dir=$dir"
    local service="${dir:0:${#dir}-2}" #0-倒数第2个字符，#dir长度
    local pb_file="${service}.proto"

    local go_out_dir="${go_out}${SEP}${dir}"

    if [ -d "$go_out_dir" ]; then
        log_warning "found existing $go_out_dir, cleaning all files under it"
        run rm -rf ${go_out}${SEP}"${dir}"${SEP}*
    else
      run mkdir -p "$go_out_dir"
    fi
    log_info "generating code for $service to $go_out_dir"

#    run protoc \
#      -I="/usr/local/include/" \
#      -I="${API_ROOT}" \
#      "--go_out=${go_out}" --go_opt=paths=source_relative \
#      --go-grpc_opt=require_unimplemented_servers=false \
#      "--go-grpc_out=${go_out}" --go-grpc_opt=paths=source_relative \
#      "${API_ROOT}${SEP}${dir}${SEP}$pb_file"
    run protoc \
      -I="D:\\develop\\go\\env\\workspace\\bin\\" \
      -I="${API_ROOT}" \
      "--go_out=${go_out}" --go_opt=paths=source_relative \
      --go-grpc_opt=require_unimplemented_servers=false \
      "--go-grpc_out=${go_out}" --go-grpc_opt=paths=source_relative \
      "${API_ROOT}${SEP}${dir}${SEP}$pb_file"

#      D:\develop\go\env\workspace
  done
  log_success "protoc gen done!"
}

echo "directories containing protos to be built: $(dirs)"
echo "found pb_files: $(pb_files)"
gen_for_modules


