#!/usr/bin/env bash

set -u

usage_exit() {
  echo "This tool make garmim maps."
  echo "Usage: $0 -m mkgmap_path -s style_path [-u] [-j] [-a] [-t] [-d dem_dir] [-l licence_dir] [-o output_dir] [-n mapname] [-e \"description\"] split_map_directory typ_path" 1>&2
  echo
  echo -e "-m\tSet mkgmap.jar location"
  echo -e "-u\tMake UTF8 map"
  echo -e "-j\tMake Shift-JIS map"
  echo -e "-a\tMake ASCII map"
  echo -e "-t\tEnable transparent option"
  echo -e "-d\tSet DEM(*.hgt) directory. If this option set, build map with internal DEM."
  echo -e "-l\tSet licence directory. must contain licence.txt and copyright.txt"
  echo -e "-o\tSet output directory prefix. default is 'output'. "
  echo -e "-n\tSet map name."
  echo -e "-e\tSet description."
  echo -e "-h\tShow help"
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
[ $# -lt 3 ] && usage_exit

OPT_UTF8=
OPT_SJIS=
OPT_ASCII=
OPT_TRANSPARENT=
OPT_DEM=
OPT_LICENCE=
PATH_MKGMAP=""
PATH_STYLE=""
PATH_DEM=""
PATH_LICENCE=""
PATH_TARGET=""
PATH_TYP=""
PATH_OUTPUT="output"
NAME_MAP=""
DESCRIPTION=`LANG=C date`

# check args
while getopts m:s:ujatd:l:o:f:p:n:e:h OPT
do
  case $OPT in
    m)
      PATH_MKGMAP=$OPTARG
      ;;
    s)
      PATH_STYLE=$OPTARG
      ;;
    u)
      OPT_UTF8=1
      ;;
    j)
      OPT_SJIS=1
      ;;
    a)
      OPT_ASCII=1
      ;;
    t)
      OPT_TRANSPARENT=1
      ;;
    d)
      OPT_DEM=1
      PATH_DEM=$OPTARG
      ;;
    l)
      OPT_LICENCE=1
      PATH_LICENCE=$OPTARG
      ;;
    o)
      PATH_OUTPUT=$OPTARG
      ;;
    f)
      FAMILY_ID=$OPTARG
      ;;
    p)
      PRODUCT_ID=$OPTARG
      ;;
    n)
      NAME_MAP=$OPTARG
      ;;
    e)
      DESCRIPTION=`echo ${OPTARG} | sed 's/"//g'`
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
PATH_TARGET=${1}
PATH_TYP=${2}

# check target directory
[ ! -d $PATH_TARGET ] && error "target directory not found. TARGET=${PATH_TARGET}"
[ ! -f "${PATH_TARGET}/template.args" ] && error "template.args not found. "
[ ! -d $PATH_STYLE ] && error "${PATH_STYLE} not found."
[ ! -f $PATH_TYP ] && error "${PATH_TYP} not found. "

if [ -n "$OPT_DEM" ]; then
  if [ ! -d $PATH_DEM ]; then
    error "DEM directory not found. DEM=${PATH_DEM}"
  fi
fi

# mkgmap parameter
PARAM_COMMON="--country-name=JAPAN --region-name=JAPAN  --region-abbr=JP1 --country-abbr=JP --route --drive-on=left  --remove-short-arcs --add-pois-to-areas  --generate-sea=extend-sea-sectors,close-gaps=6000 --gmapsupp  --index --tdbfile --nsis --max-jobs  --reduce-point-density=4.0 --reduce-point-density-polygon=8.0  --style-file=${PATH_STYLE}"

if [ -n "$OPT_DEM" ]; then
  PARAM_COMMON="${PARAM_COMMON} --show-profiles=1 --dem=${PATH_DEM} --dem-dists=3312,13248,26512,53024"
fi

if [ -n "$OPT_TRANSPARENT" ]; then
  PARAM_COMMON="${PARAM_COMMON} --transparent --draw-priority=1"
fi

if [ -n "$OPT_LICENCE" ]; then
  PARAM_COMMON="${PARAM_COMMON} --license-file=${PATH_LICENCE}/license.txt  --copyright-file=${PATH_LICENCE}/copyright.txt"
fi

if [ -n "$NAME_MAP" ]; then
  PARAM_COMMON="${PARAM_COMMON} --family-name=\"${NAME_MAP}\" --series-name=\"${NAME_MAP}\""
fi

if [ -n "$FAMILY_ID" ]; then
  PARAM_COMMON="${PARAM_COMMON} --family-id=${FAMILY_ID}"
fi

if [ -n "$PRODUCT_ID" ]; then
  PARAM_COMMON="${PARAM_COMMON} --product-id=${PRODUCT_ID}"
fi

PARAM_UTF8="--code-page=65001 --lower-case --name-tag-list=name:ja,name,name:en"

PARAM_SJIS="--code-page=932 --lower-case --name-tag-list=name:ja,name,name:en"

PARAM_ASCII="--latin1 --lower-case --name-tag-list=name:en,name:fr,brand,name:ja_rm,name:ja-Latn,name:ja_kana,int_name,name"


pushd $PATH_TARGET

# UTF8
if [ -n "$OPT_UTF8" ]; then
  info "run mkgmap. Encode:UTF8."
  java -Xmx8G -jar ${PATH_MKGMAP} ${PARAM_COMMON} ${PARAM_UTF8} --output-dir=${PATH_OUTPUT}_utf8 -c template.args --description="${DESCRIPTION}" ${PATH_TYP}
  rtn=$?; [ $rtn -ne 0 ] && warn "status=${rtn}"
fi

# Shift-JIS
if [ -n "$OPT_SJIS" ]; then
  info "run mkgmap. Encode:Shift-JIS."
  java -Xmx8G -jar ${PATH_MKGMAP} ${PARAM_COMMON} ${PARAM_SJIS} --output-dir=${PATH_OUTPUT}_sjis -c template.args --description="${DESCRIPTION}" ${PATH_TYP}
  rtn=$?; [ $rtn -ne 0 ] && warn "status=${rtn}"
fi

# ascii
if [ -n "$OPT_ASCII" ]; then
  info "run mkgmap. Encode:ASCII."
  java -Xmx8G -jar ${PATH_MKGMAP} ${PARAM_COMMON} ${PARAM_ASCII} --output-dir=${PATH_OUTPUT}_ascii -c template_roman.args --description="${DESCRIPTION}" ${PATH_TYP}
  rtn=$?; [ $rtn -ne 0 ] && warn "status=${rtn}"
fi

info "${0} Finished. TARGET=${PATH_TARGET}"

popd
