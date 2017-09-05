rem “™‚ü‚È‚µ‚Ì’n}‚Ì‚Ýì‚é‚Æ‚«‚Í1A“™‚ü‚ ‚è‚Ì’n}‚Ì‚Ýì‚é‚Æ‚«‚Í2A—¼•ûì‚é‚Æ‚«‚Í0
set TARGET_TYPE=2

set BASE_DIR=%~dp0
set SOURCE_URI=http://download.geofabrik.de/asia/japan-latest.osm.pbf
set MAP_FILE_ORG=%BASE_DIR%\..\map_data\japan-latest.osm.pbf
set DIC_FILE=%BASE_DIR%\..\kakasi-dic\SKK-JISYO.geo %BASE_DIR%\..\kakasi-dic\SKK-JISYO.station
set KANWADICTPATH=%BASE_DIR%\..\kakasi\share\kakasi\kanwadict
set ITAIJIDICTPATH=%BASE_DIR%\..\kakasi\share\kakasi\itaijidict
set SPLITTER=java -Xmx2000M -jar "%BASE_DIR%\..\splitter\splitter.jar"
set MKGMAP=java -Xmx2000M -jar "%BASE_DIR%\..\mkgmap\mkgmap.jar"
set TMPFILE=tmp.dat
set PATH=%PATH%;%BASE_DIR%\..\;%BASE_DIR%\..\kakasi\bin;
set MKGMAPARGS=template2.args
set MKGMAP_SEARCHARGS=template3.args
set MAPID_PREFIX=6331
set MAPID_SEARCH_PREFIX=6332

@echo off
echo 'Hit any key to continue...'
pause

cd %BASE_DIR%

if "%1"=="" goto get_from_server

set MAP_FILE_ORG=%1
goto start_convert


:get_from_server
rem #Get osm file
pushd ..\map_data
wget --progress=dot:mega --timestamping %SOURCE_URI%
popd


:start_convert
rem #Go to output directory
mkdir output
cd output

rem #Clean up old files
for %%i in (*.osm) do (
  del %%i
)
for %%i in (%MAPID_PREFIX%*.img) do (
  del %%i
)
for %%i in (%MAPID_SEARCH_PREFIX%*.img) do (
  del %%i
)
if exist gmapsupp.img del gmapsupp.img

rem #Exclude empty contours
rem set CONTOUR_DIR="..\contour\"
rem if exist %CONTOUR_DIR% (
rem  pushd %CONTOUR_DIR%
rem  setlocal enabledelayedexpansion
rem  for %%i in (5327*.osm.pbf) do (
rem    set contfile=%%i
rem    if %%~zi leq 150 rename !contfile! !contfile:.osm=.osm.skip!
rem  )
rem  endlocal
rem  popd
rem )

rem #Split file
copy ..\areas.list .
if exist areas.list set SPLITTER_OPT_AREA=--split-file=areas.list
%SPLITTER% --keep-complete=true --description="OSM Japan" --max-nodes=1000000 --search-limit=10000000 --resolution=12 %SPLITTER_OPT_AREA% --mapid=%MAPID_PREFIX%0001 %MAP_FILE_ORG%

rem #Convert Kanji to Roman character
for %%i in (*.osm.pbf) do (
  osmconvert %%i | perl ..\rep_list_pre.pl | iconv -c -f UTF-8 -t SHIFT-JIS | kakasi -Ha -Ka -Ja -Ea -ka %DIC_FILE% | perl -pi.bak -e "s/\^/-/g" > %%i.roman
)

cat template.args | sed -e "s/\.osm\.pbf/\.osm\.pbf\.roman/g;" > %MKGMAPARGS%
copy /b ..\tmz.args+%MKGMAPARGS% japan.args /y

cat %MKGMAPARGS% | sed -e "s/mapname: [0-9][0-9][0-9][0-9]/mapname: %MAPID_SEARCH_PREFIX%/g;" > %MKGMAP_SEARCHARGS%
copy /b ..\tmz_search.args+%MKGMAP_SEARCHARGS% japan_search.args /y

if "%TARGET_TYPE%" == "0" (
  %MKGMAP% -c japan_search.args ..\tmz_search.typ
  if exist gmapsupp_search.img del gmapsupp_search.img
  ren gmapsupp.img gmapsupp_search.img
  %MKGMAP% -c japan.args ..\tmz.typ
  if exist gmapsupp_1.zip del gmapsupp_1.zip
  7z.exe a gmapsupp_1.zip gmapsupp.img gmapsupp_search.img osmmap_license.txt
  %MKGMAP% -c ..\tmz.args %MAPID_PREFIX%*.img ..\tmz.typ ..\contour\5327*.osm.pbf
  if exist gmapsupp_1cntr.zip del gmapsupp_1cntr.zip
  7z.exe a gmapsupp_1cntr.zip gmapsupp.img gmapsupp_search.img osmmap_license.txt
)

if "%TARGET_TYPE%" == "1" (
  %MKGMAP% -c japan.args ..\tmz.typ
  if exist gmapsupp_1.zip del gmapsupp_1.zip
  7z.exe a gmapsupp_1.zip gmapsupp.img osmmap_license.txt
)

if "%TARGET_TYPE%" == "2" (
  %MKGMAP% -c japan.args ..\tmz.typ ..\contour\5327*.osm.pbf
  if exist gmapsupp_1cntr.zip del gmapsupp_1cntr.zip
  7z.exe a gmapsupp_1cntr.zip gmapsupp.img osmmap_license.txt
)

pause
