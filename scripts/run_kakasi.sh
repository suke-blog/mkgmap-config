#!/usr/bin/env bash

set -u

usage_exit() {
  echo "This tool convert osm character code, utf8 to ascii(romaji)."
  echo "Usage: $0 target_path" 1>&2
  exit 1
}

info() {
  # color:green
  echo -e "\033[0;32m[INFO]\033[0;39m\t${1}"
}

warn() {
  # color:yellow
  echo -e "\033[0;33m[WARN]\033[0;39m\t${1}"
}

error() {
  # color:red
  echo -e "\033[0;31m[ERROR]\033[0;39m\t${1}"
  exit 1
}

# check args num
[ $# -ne 1 ] && usage_exit

PATH_TARGET=$1
[ ! -d $PATH_TARGET ] && error "target directory not found. TARGET=${PATH_TARGET}"
[ ! -f ${PATH_TARGET}/template.args ] && error "template.args not found."

info "convert start"

# convert osm, utf8 to ascii(romaji)
find ${PATH_TARGET} -name "*.pbf" -exec sh -c "osmconvert {} --drop-author --drop-version | perl  ./rep_list_pre.pl | iconv -c -f UTF-8 -t SHIFT-JIS | kakasi -Ha -Ka -Ja -Ea -ka  ./kakasi-ext-dic/SKK-JISYO.geo ./kakasi-ext-dic/SKK-JISYO.station | osmconvert - --out-pbf -o={}.roman.pbf" \;

# convert template.args
cat ${PATH_TARGET}/template.args | sed -e "s/\.osm\.pbf/\.osm\.pbf\.roman.pbf/g;" > ${PATH_TARGET}/template_roman.args

info "$0 Finished. TARGET=${PATH_TARGET}"
