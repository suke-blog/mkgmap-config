#!/usr/bin/env bash

set -u

usage_exit() {
  echo "This tool make garmim maps."
  echo "Usage: $0 [-h] job.csv" 1>&2
  echo
  echo -e "-h\tShow this help."
  echo
  echo "Environment variables:"
  echo
  echo -e "MKGMAP\t\tmkgmap.jar to use"
  echo -e "SPLITTER\tsplitter.jar to use"
  echo -e "CONFIG\t\tpath to mkgmap-config directory"
  echo -e "DEM\t\tpath to SRTM(*.hgt) directory"
  echo -e "LICENSE\tpath to license directory contain copyright.txt/license.txt"
  echo -e "OUTPUT\toutput directory (default:output)"
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
PATH_JOB=${1}

# check job file
[ ! -f "${PATH_JOB}" ] && error "config file:${PATH_JOB} not found."

PATH_MKGMAP=`readlink -f "${MKGMAP:-mkgmap}"`
PATH_SPLITTER=`readlink -f "${SPLITTER:-mkgmap-splitter}"`
PATH_CONFIG=`readlink -f "${CONFIG:-./../}"`
PATH_DEM=`readlink -f "${DEM:-./work/srtm}"`
PATH_LICENSE=`readlink -f "${LICENSE:-./work/licence}"`
DIR_OUTPUT="${OUTPUT:-output}"

# read config-job
for line in `cat ${PATH_JOB} | grep -v ^#`
do
  CMD=`echo ${line} | cut -d ',' -f 1`
  VALUE=`echo ${line} | cut -d ',' -f 2`

  case "$CMD" in
    "CONFIG"  ) PATH_CONFIG=`readlink -f $VALUE` ;;
    "DEM"     ) PATH_DEM=`readlink -f $VALUE` ;;
    "LICENCE" ) PATH_LICENCE=`readlink -f $VALUE` ;;
    "MAP"     ) PATH_MAP=`readlink -f $VALUE` ;;
    "OUTPUT"  ) DIR_OUTPUT=$VALUE ;;
    "MKGMAP"     )
      # parse format
      # JOB, FamilyID, ProductID, Map name, description, style_name, typ_name, coding[u/j/a], transparent[y/n], DEM[y/n]
      MAP_FAMILY_ID=`echo ${line} | cut -d ',' -f 2`
      MAP_PRODUCT_ID=`echo ${line} | cut -d ',' -f 3`
      MAP_NAME=`echo ${line} | cut -d ',' -f 4`
      MAP_DESCRIPTION=`echo ${line} | cut -d ',' -f 5`
      MAP_STYLE=`echo ${line} | cut -d ',' -f 6`
      MAP_TYP=`echo ${line} | cut -d ',' -f 7`
      MAP_CODING=`echo ${line} | cut -d ',' -f 8`
      MAP_TRANSPARENT=`echo ${line} | cut -d ',' -f 9`
      MAP_DEM=`echo ${line} | cut -d ',' -f 10`

      info "processing MAP_NAME:${MAP_NAME}..."
      echo "debug::line ${line}"

      PARAMS="-m ${PATH_MKGMAP} -${MAP_CODING} -s ${PATH_CONFIG}/styles/${MAP_STYLE} -n ${MAP_NAME} -o ${DIR_OUTPUT}"
      [ "$MAP_FAMILY_ID" != "" ] && PARAMS="$PARAMS -f $MAP_FAMILY_ID"
      [ "$MAP_PRODUCT_ID" != "" ] && PARAMS="$PARAMS -p $MAP_PRODUCT_ID"
      [ "$MAP_DESCRIPTION" != "" ] && PARAMS="$PARAMS -e $MAP_DESCRIPTION"
      [ "$MAP_TRANSPARENT" != "n" ] && PARAMS="$PARAMS -t $MAP_TRANSPARENT"
      [ "$MAP_DEM" == "y" ] && PARAMS="$PARAMS -d $PATH_DEM"
      [ -d $PATH_LICENSE ] && PARAMS="$PARAMS -l $PATH_LICENSE"

      # copy dummy template_roman.args if not exist.
      if [ ! -f "${PATH_MAP}/template_roman.args" ]; then
        warn "template_roman.args not found. using template.args."
        ln -s ${PATH_MAP}/template.args ${PATH_MAP}/template_roman.args
      fi

      # run mkgmap
      ./run_mkgmap.sh ${PARAMS} ${PATH_MAP} ${PATH_CONFIG}/typ/${MAP_TYP}
      #echo "debug:: ./run_mkgmap.sh ${PARAMS} ${PATH_MAP} ${PATH_CONFIG}/typ/${MAP_TYP}"
      ;;
    "SPLITTER"  )
      # parse format
      # SPLITTER, mapid, osm_path, output_path, convert_to_roman[y/n]
      SPLIT_MAPID=$VALUE
      SPLIT_OSM=`echo ${line} | cut -d ',' -f 3`
      SPLIT_ROMAN=`echo ${line} | cut -d ',' -f 4`

      info "splitting OSM:${SPLIT_OSM} output:${PATH_MAP}"
      echo "debug::SPLITTER ${line}"

      PARAMS="-m ${PATH_SPLITTER}"
      [ "$SPLIT_MAPID" != "" ] && PARAMS="$PARAMS -i $SPLIT_MAPID"

      ./run_splitter.sh $PARAMS $SPLIT_OSM $PATH_MAP
      #echo "./run_splitter.sh $PARAMS $SPLIT_OSM $PATH_MAP"

      # convert to roman
      if [ "$SPLIT_ROMAN" == "y" ]; then
        ./run_kakasi.sh $PATH_MAP
        #echo "./run_kakasi.sh $PATH_MAP"
      fi

      ;;
  esac
done
