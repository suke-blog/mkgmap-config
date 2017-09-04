
set SRTM2OSM="C:\map_tool\Srtm2Osm-mybuild_141207\Srtm2Osm\Srtm2Osm.exe"
set SRTM_ARGS=-step 20 -cat 500 100 -large

SETLOCAL ENABLEDELAYEDEXPANSION
set /a file_num = 53270000

for /F "tokens=1,2,3,4" %%i in (tile_list.txt) do (
  set /a file_num+=1
  echo box=%%i %%j %%k %%l
  echo file=!file_num!
  rem # download and convert to osm
  %SRTM2OSM% -bounds1 %%i %%j %%k %%l -o tmp.osm %SRTM_ARGS%
  perl modify_coord.pl < tmp.osm > !file_num!.osm
)
ENDLOCAL

pause
