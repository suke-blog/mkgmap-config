#!/bin/bash

# 1:generate map without contour, 2:with contour
TARGET_TYPE=2

BASE_DIR=$(cd $(dirname $0) && pwd)
SOURCE_URL="http://download.geofabrik.de/asia/japan-latest.osm.pbf"
MAP_FILE_ORG="japan-latest.osm.pbf"
DIC_FILE="${BASE_DIR}/../kakasi-dic/SKK-JISYO.geo ${BASE_DIR}/../kakasi-dic/SKK-JISYO.station"
SPLITTER="java -jar ${BASE_DIR}/../splitter/splitter.jar"
MKGMAP="java -jar ${BASE_DIR}/../mkgmap/mkgmap.jar"
TMPFILE="tmp.dat"
MKGMAPARGS="template2.args"
MKGMAP_SEARCHARGS="template3.args"
MAPID_PREFIX="6331"
MAPID_SEARCH_PREFIX="6332"

export JAVA_OPTS="-Xmx2048M"

echo 'Hit any key to continue...'
read Wait

cd `dirname $0`

if [$1 -eq ""]
then
	#Get osm file
	pushd ../map_data
	wget --progress=dot:mega --timestamping $SOURCE_URL
	MAP_FILE_ORG=$(pwd)/$MAP_FILE_ORG
	popd
else
	MAP_FILE_ORG=$1
fi


#Go to output directory
mkdir output
pushd output

#Clean up old files
rm *.img
rm *.osm
rm *.roman

#Split file
eval "cp ../areas.list ."
$SPLITTER --keep-complete=true --description="OSM Japan" --max-nodes=1000000 --search-limit=10000000 --resolution=12 --split-file=areas.list --mapid=${MAPID_PREFIX}0001 $MAP_FILE_ORG

#Convert Kanji to Roman character
for file in `find . -name "*.osm.pbf"`; do
	osmconvert $file | perl ../rep_list_pre.pl | iconv -c -f UTF-8 -t SHIFT-JIS | kakasi -Ha -Ka -Ja -Ea -ka $DIC_FILE | perl -pi.bak -e "s/\^/-/g" > ${file}.roman
done


cat template.args | sed -e "s/\.osm\.pbf/\.osm\.pbf\.roman/g;" > $MKGMAPARGS
cat ../tmz.args $MKGMAPARGS > japan.args

cat $MKGMAPARGS | sed -e "s/mapname: [0-9][0-9][0-9][0-9]/mapname: ${MAPID_SEARCH_PREFIX}/g;" > $MKGMAP_SEARCHARGS
cat ../tmz_search.args $MKGMAP_SEARCHARGS > japan_search.args

if [ $TARGET_TYPE -eq "0" ]
then
  $MKGMAP -c japan_search.args ../tmz_search.typ
  mv gmapsupp.img gmapsupp_search.img
  $MKGMAP -c japan.args ../tmz.typ
  $MKGMAP -c ../tmz.args ${MAPID_PREFIX}*.img ../tmz.typ ../contour/*.osm ../contour/*.osm.pbf
elif [ $TARGET_TYPE -eq "1" ]
then
  $MKGMAP -c japan.args ../tmz.typ
elif [ $TARGET_TYPE -eq "2" ]
then
  $MKGMAP -c japan.args ../tmz.typ ../contour/*.osm ../contour/*.osm.pbf
fi

