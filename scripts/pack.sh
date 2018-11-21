#!/usr/bin/env bash

set -u

usage_exit() {
  echo "This tool make release data."
  echo "Usage: $0 [-h] target_directory" 1>&2
  echo
  echo "target_directory must contain gmasupp*.img, license.txt, copyright.txt"
  echo
  echo -e "-h\tShow this help."
  echo
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
[ $# -lt 1 ] && usage_exit

# check args
while getopts h OPT
do
  case $OPT in
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
DIR_DATA=${1}

[ ! -d "${DIR_DATA}" ] && error "directory:${DIR_DATA} not found."
[ ! -f "${DIR_DATA}/license.txt" ] && error "licence.txt not found."
[ ! -f "${DIR_DATA}/copyright.txt" ] && error "copyright.txt not found."

pushd $DIR_DATA

for PATH_FILE in `ls *.img`; do
  info "compressing: $PATH_FILE ..."
  #ARCHIVE_FILE=`echo $PATH_FILE | sed 's/\.[^\.]*$//'`
  zip -9 ${PATH_FILE%.*}_$(date -I).zip ${PATH_FILE} license.txt copyright.txt
  mv $PATH_FILE ${PATH_FILE}.done
done

popd
