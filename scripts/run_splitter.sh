#!/usr/bin/env bash

set -u

usage_exit() {
  echo "run splitter script."
  echo "Usage: $0 -m splitter_path osm_path output_dir" 1>&2
  echo
  echo -e "-m\tSet splitter.jar location"
  echo -i "-i\tSet MAP_ID"
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
#[ $# -ne 3 ] && usage_exit

PATH_SPLITTER="mkgmap-splitter"
MAP_ID="63500001"
PATH_OSM=
PATH_OUTPUT=

# check args
while getopts m:i: OPT
do
  case $OPT in
    m)
      PATH_SPLITTER=$OPTARG
      ;;
    i)
      MAP_ID=$OPTARG
      ;;
    h)
      usage_exit
      ;;
    \?)
      usage_exit
      ;;
    *)
      usage_exit
      ;;
  esac
done

shift `expr ${OPTIND} - 1`
PATH_OSM=$1
PATH_OUTPUT=$2

[ ! -f $PATH_SPLITTER ] && error "${PATH_SPLITTER} not found."
[ ! -f $PATH_OSM ] && error "${PATH_OSM} not found."
[ -d $PATH_OUTPUT ] && error "output directory exist. OUTPUT=${PATH_OUTPUT}"

mkdir -p ${PATH_OUTPUT}

#PARAM_JAVA_XMX=26
PARAM_JAVA_XMX=64
PARAM_RESOLUTION=13

PARAM_COMMON=" --keep-complete=true --search-limit=10000000 --max-areas=2048 --mapid=${MAP_ID} --output-dir=${PATH_OUTPUT}"

# check filesize (larger than 2GByte or not)
filesize=`wc -c < ${PATH_OSM}`
if [ $filesize -gt 2000000000 ]; then
  PARAM_COMMON="${PARAM_COMMON} --num-tiles=2000"
else
  PARAM_COMMON="${PARAM_COMMON} --max-nodes=1600000"
fi

# try split osm to tiles
for res in 11 12 13 14; do
#for res in 13 12 11 14; do
  info "start process. mapid=${MAP_ID}, resolution=${res}"
  java -Xmx${PARAM_JAVA_XMX}G -jar $PATH_SPLITTER ${PARAM_COMMON} --resolution=${res} ${PATH_OSM} &
  pid_splitter=$!

  # run jmap to force GC(interval=20sec)
  watch -n 20 jmap -histo:live ${pid_splitter} > /dev/null 2>&1 &
  pid_watch=$!

  # wait for complete splitter process
  wait $pid_splitter
  rtn=$?
  kill -s kill ${pid_watch}

  if [ $rtn -eq 0 ]; then
    info "splitter maybe successful."
    break
  fi
  warn "status=${rtn}"

  # check error
  if [ -f ${PATH_OUTPUT}/areas.list ]; then
    area_count=`cat ${PATH_OUTPUT}/areas.list | grep -e "^[0-9].*" | wc -l`
    if [ $area_count -lt 2048 ]; then
      info "areas.list : ok (tile:${area_count})"
      warn "Maybe, splitter failed with OutOfMemoryError. Try to increase java_heap -XmxNN."
    else
      warn "tile count = ${area_count}(>2048). You will need to fix --num-tiles."
    fi
  else
    warn "Maybe, splitter failed with finding a correct split. Retry..."
  fi
done

info "$0 Finished."
