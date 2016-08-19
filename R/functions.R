# set paths to relevant resources
path <- "https://dds.cr.usgs.gov/srtm/version2_1/SRTM3/Eurasia/"
file_coverage_UK <- read.csv("file_list_UK.csv")

# define download function
downloadUKterrain <- function(mainDir){
        # download UK data
        path <- "https://dds.cr.usgs.gov/srtm/version2_1/SRTM3/Eurasia/"
        # read in lists of data sets
        file_coverage_UK <- read.csv(paste0(mainDir, "/", "file_list_UK.csv"))
        # set the datafile column as the download list
        file_list_UK <- file_coverage_UK$datafile
        download_dir <- "Data_Downloads_UK"
        ifelse(!dir.exists(file.path(mainDir, download_dir)), dir.create(file.path(mainDir, download_dir)), FALSE)
        setwd(paste0(mainDir, "/", download_dir))

        for(file in file_list_UK){
                filepath <- paste0(path, file)
                download.file(filepath, destfile = file, method = 'curl')
                unzip(paste0(mainDir, "/", download_dir, "/", file))
                file.remove(paste0(mainDir, "/",download_dir, "/", file))
        }
}

# check coverage of UK terrain data, helps with tile selection
showUKterrain <- function(){
        library(leaflet)
        # show a map of UK coverage in SRTM data
        leaflet(data = file_coverage_UK) %>% addTiles() %>%
                addMarkers(~lng, ~lat, popup = ~as.character(paste0("Lat=", lat," Lon =", lng)))
}

# map terrain tile
mapterrain <- function(tile){
        library(raster)
        library(rgdal)
        library(stringr)
        elevation <- raster(tile)
        # Map the terrain file
        pal <- colorNumeric(c("#0C2C84", "#41B6C4", "#FFFFCC"), values(elevation),
                            na.color = "transparent")
        tile_name <- str_sub(tile, start= -11)
        title_string <- paste0(tile_name, " SRTM Elev. (m)")
        leaflet() %>% addTiles() %>%
                addRasterImage(elevation, colors = pal, opacity = 0.8) %>%
                addLegend(pal = pal, values = values(elevation),
                          title = title_string)
}

# convert terrain to UK coordinate system
toUKterrain <- function(filepath, tile){
        setwd(filepath)
        library(raster)
        library(rgdal)
        library(sp)
        elevation <- raster(tile)
        ukgrid = "+init=epsg:27700"
        UKprojected <- projectRaster(elevation, crs= ukgrid)
        writeRaster(UKprojected, filename="UK_terrain.tif", format="GTiff", overwrite=TRUE)
}
