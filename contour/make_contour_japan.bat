rem generate contour script
rem 2017-09-04

@echo off

set PHYGHTMAP_PATH="phyghtmap"
set JOBS=2

rem ---<contor config>-------------------
rem SRTM resolution. possible value is 1 or 3. 1:SRTM-1,3:SRTM-3.
set SRTM=1

rem specify contour line step size in meters.
set CONTOUR_STEP=10

rem pecify a string of two comma seperated integers for major and medium elevation categories.
set CONTOUR_LINE_CAT=500,50

rem ---<Earthdata Account>---------------
rem username and password for earchdata login.
set EARTHDATA_USER=
set EARTHDATA_PASSWORD=

echo "generate contor script\n"
echo "<<Press hit any key to continue...>>"
pause

%PHYGHTMAP_PATH% --pbf --polygon=japan.poly --output-prefix=japan_srtm --srtm=%SRTM% --step=%CONTOUR_STEP% --line-cat=%CONTOUR_LINE_CAT% --start-node-id=20000000000 --start-way-id=10000000000 --write-timestamp --no-zero-contour --earthdata-user=%EARTHDATA_USER% --earthdata-password=%EARTHDATA_PASSWORD% --corrx=0.0005 --corry=0.0005 --jobs=%JOBS%

echo "Complete."
