#!/bin/bash
# generate contour script
# 2017-09-04

PHYGHTMAP_PATH="phyghtmap"
JOBS=2

# ---<contor config>-------------------
# SRTM resolution. possible value is 1 or 3. 1:SRTM-1,3:SRTM-3.
SRTM=1

# specify contour line step size in meters.
CONTOUR_STEP=20

# pecify a string of two comma seperated integers for major and medium elevation categories.
CONTOUR_LINE_CAT=500,50

# ---<Earthdata Account>---------------
# username and password for earchdata login.
EARTHDATA_USER=keisuke.horii
EARTHDATA_PASSWORD=Hogemoge2nasa



echo "generate contor script"
echo "<<Press hit any key to continue...>>"
read Wait

$PHYGHTMAP_PATH --pbf --polygon=japan.poly --output-prefix=japan_srtm --srtm=$SRTM --step=$CONTOUR_STEP --line-cat=$CONTOUR_LINE_CAT --start-node-id=20000000000 --start-way-id=10000000000 --write-timestamp --no-zero-contour --earthdata-user=$EARTHDATA_USER --earthdata-password=$EARTHDATA_PASSWORD --corrx=0.0005 --corry=0.0005 --jobs=$JOBS

echo "Complete."
