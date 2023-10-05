#!/usr/bin/env sh

#gdalwarp -overwrite -s_srs EPSG:4326 -t_srs EPSG:32113 -r near -of GTiff ./input/n35w106.tif ./output/reprojected.tif

# https://gdal.org/programs/gdalwarp.html
echo "\nClipping..."
gdalwarp -overwrite -te -105.8043495 35.5711759 -105.7954624 35.5785203 ./input/n35w106.tif ./output/clipped.tif

# https://gdal.org/programs/gdal_calc.html
echo "\nConverting from meters to feet..."
gdal_calc.py --overwrite -A ./output/clipped.tif --outfile=./output/clipped_feet.tif --calc="A*3.28084"

# https://gdal.org/programs/gdal_contour.html
echo "\nGenerating Contours..."
gdal_contour -a elev -3d -i 5.0 ./output/clipped_feet.tif ./output/contours_feet_5.gpkg
gdal_contour -a elev -3d -i 10.0 ./output/clipped_feet.tif ./output/contours_feet_10.gpkg
gdal_contour -a elev -3d -i 100.0 ./output/clipped_feet.tif ./output/contours_feet_100.gpkg

echo "\nConverting Contours to DXF..."
ogr2ogr -zfield elev -dim XYZ -f DXF output/contours_feet_5.dxf output/contours_feet_5.gpkg
ogr2ogr -zfield elev -dim XYZ -f DXF output/contours_feet_10.dxf output/contours_feet_10.gpkg
ogr2ogr -zfield elev -dim XYZ -f DXF output/contours_feet_100.dxf output/contours_feet_100.gpkg
