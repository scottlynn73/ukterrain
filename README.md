# ukterrain
## Downloading and other helpful functions for SRTM3 datasets in the UK

To install the tool use

`library(devtools)`


`install_github('scottlynn73/ukterrain')`


`library(ukterrain)`

`library(magrittr)`

The user may wish to download a UK subset of Shuttle Radar Topography data but is unsure which tiles from the extensive list are included in the UK coverage. This package provides a useful means of downloading,checking coverage, mapping, and converting to OS grid co-ordinate reference system from the native format.

###Downloading data
To download data simple pass the downloadUKterrain() function with your desired directory location as the only argument, like so:

`downloadUKterrain("/Users/Scott/Downloads/")`

This will create a directory of files called Data_Downloads_UK in the directory containing the terrain files. This should only need to be run once.

### Viewing the extent of data and picking the correct tile for your site
The package includes the showUKterrain function which produces a webmap showing the locations of the tiles included in the dataset. This is useful in selecting a tile for use later, the user can click the map points to get the reference for the tile so that they may select this tile for mapping or conversion.

Use the function like so (no arguments are needed)

`showUKterrain()`

### View terrain file in a webmap
To show one of the tiles we downloaded in a map use the mapUKterrain function, like so

`mapterrain("/Users/Scott/Downloads/N55W005.hgt")`

Alternatively you can use `mapterrain(file.choose())` to select a file using Windows Explorer or Finder in OSX.

A web map should be produced showing the terrain coverage for the file. 


### Converting to OS grid EPSG:27700 
Sometimes the user may wish to convert the co-ordinate reference system of the tile to the OS grid format. To do this pass the toUKterrain() function with the filepath and filename, like so,

`toUKterrain("/Users/Scott/Downloads/", "N55W005.hgt")`

The new file will be called "UK_Terrain.tif" and will be placed in the working directory.
