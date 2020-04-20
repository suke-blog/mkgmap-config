#!/usr/bin/env bash

set -u

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

TARGET_OSM="./work/japan-latest.osm.pbf"
CONTOUR_DEM10="./work/japan-contour-dem10b.osm.pbf"
CONTOUR_DEM5="./work/japan-contour-dem5.osm.pbf"

OUTPUT_OSM_CONTOUR_DEM10="./work/japan-osm-with-contour-dem10.osm"
OUTPUT_OSM_CONTOUR_DEM5="./work/japan-osm-with-contour-dem5.osm"

[ ! -f ${TARGET_OSM} ] && error "cannot find ${TARGET_OSM}."
[ ! -f ${CONTOUR_DEM10} ] && error "cannot find ${CONTOUR_DEM10}."
[ ! -f ${CONTOUR_DEM5} ] && error "cannot find ${CONTOUR_DEM5}."

# for Garmin
info "make map with contour for garmin."
if [ ! -f "${OUTPUT_OSM_CONTOUR_DEM10}.pbf" ]; then
  osmconvert --out-o5m ${TARGET_OSM} | osmconvert --out-pbf - ${CONTOUR_DEM10} -o=${OUTPUT_OSM_CONTOUR_DEM10}.pbf &
else
  warn "file:${OUTPUT_OSM_CONTOUR_DEM10}.pbf is exist. skipped."
fi

if [ ! -f "${OUTPUT_OSM_CONTOUR_DEM5}.pbf" ]; then
  osmconvert --out-o5m ${TARGET_OSM} | osmconvert --out-pbf - ${CONTOUR_DEM5} -o=${OUTPUT_OSM_CONTOUR_DEM5}.pbf &
else
  warn "file:${OUTPUT_OSM_CONTOUR_DEM5}.pbf is exist. skipped."
fi

wait
info "done."

# for Mapsme
info "make map with contour for mapsme."
if [ ! -f "${OUTPUT_OSM_CONTOUR_DEM10}.o5m" ]; then
  osmconvert --out-o5m ${OUTPUT_OSM_CONTOUR_DEM10}.pbf --modify-way-tags="ele= to name=" -o=${OUTPUT_OSM_CONTOUR_DEM10}.o5m &
else
  warn "file:${OUTPUT_OSM_CONTOUR_DEM10}.o5m is exist. skipped."
fi

if [ ! -f "${OUTPUT_OSM_CONTOUR_DEM5}.o5m" ]; then
  osmconvert --out-o5m ${OUTPUT_OSM_CONTOUR_DEM5}.pbf --modify-way-tags="ele= to name=" -o=${OUTPUT_OSM_CONTOUR_DEM5}.o5m &
else
  warn "file:${OUTPUT_OSM_CONTOUR_DEM5}.o5m is exist. skipped."
fi

wait
info "done."
