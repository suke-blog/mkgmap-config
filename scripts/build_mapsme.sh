#!/usr/bin/env bash


REGIONS="$(ls ../../data/borders/Japan_*.poly)" PLANET=/media/kiri/DATA/git/suke-blog/mkgmap-config/scripts/work/japan-osm-with-contour-dem10.osm.o5m TARGET=/media/kiri/DATA/git/suke-blog/mkgmap-config/scripts/work/mapsme-with-contour-dem10 SRTM_PATH=/media/kiri/DATA/git/suke-blog/mkgmap-config/scripts/work/srtm/ NS=sqlite ./generate_planet.sh -r
REGIONS="$(ls ../../data/borders/Japan_*.poly)" PLANET=/media/kiri/DATA/git/suke-blog/mkgmap-config/scripts/work/japan-osm-with-contour-dem5.osm.o5m TARGET=/media/kiri/DATA/git/suke-blog/mkgmap-config/scripts/work/mapsme-with-contour-dem5 SRTM_PATH=/media/kiri/DATA/git/suke-blog/mkgmap-config/scripts/work/srtm/ NS=sqlite ./generate_planet.sh -r
