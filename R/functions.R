#' Download data from the Shuttle Radar Topography Mission for the UK
#'
#' This function allows you to conveniently download UK terrain data from the
#' SRTM3 dataset. This is the highest resolution SRTM dataset currenltly
#' available and is particularly useful for running air qulity models.
#'
#' To run the downloader run the function with the desired download location
#' as the only argument. This will place a copy of all UK SRTM3 files in that
#' directory.
#'
#' @param Defaults to TRUE.
#' @keywords terrain
#' @export
#' @examples
#' downloadUKterrain("/Users/Scott/Downloads/")
#'
downloadUKterrain <- function(mainDir){
        path <- "https://dds.cr.usgs.gov/srtm/version2_1/SRTM3/Eurasia/"
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

#' Show the coverage of the SRTM3 datasets for the UK in a leaflet map.
#'
#' This convenience functions shows the locations of the SRTM3 data tiles in
#' the UK. Each point in the map denotes the origin of the tile at the south
#' west corner. The function has no arguments, so run with empty brackets.
#'
#' @param Defaults to TRUE.
#' @keywords terrain
#' @export
#' @examples
#' showUKterrain()
#'
# check coverage of UK terrain data, helps with tile selection
showUKterrain <- function(){
        # show a map of UK coverage in SRTM data
        leaflet::leaflet(data = file_coverage_UK) %>% addTiles() %>%
                addMarkers(~lng, ~lat,
                           popup = ~as.character(paste0("Lat=", lat," Lon =", lng)))
}

#' Prepare a simple map with a terrain tile from the SRTM3 dataset using
#' leaflet. To run the function simply pass the desired .hgt file to the
#' function as an argument.
#'
#' @param Defaults to TRUE.
#' @keywords terrain
#' @export
#' @examples
#' mapterrain("/Users/Scott/Downloads/N55W005.hgt")
#'
mapterrain <- function(tile){
        elevation <- raster::raster(tile)
        pal <- leaflet::colorNumeric(c("#0C2C84", "#41B6C4", "#FFFFCC"), values(elevation), na.color = "transparent")
        tile_name <- stringr::str_sub(tile, start= -11)
        title_string <- paste0(tile_name, " SRTM Elev. (m)")
        leaflet::leaflet() %>% addTiles() %>%
                addRasterImage(elevation, colors = pal, opacity = 0.8) %>%
                addLegend(pal = pal, values = values(elevation),
                          title = title_string)
}

#' Convert SRTM3 dataset to the OS grid coordinate reference system EPSG 27700.
#'
#' To run the converter run the function with the desired file for projection
#' to the OS grid coordinate system as the only argument.
#'
#' @param Defaults to TRUE.
#' @keywords terrain
#' @export
#' @examples
#' toUKterrain("/Users/Scott/Downloads/", "N55W005.hgt")
#'
toUKterrain <- function(filepath, tile){
        setwd(filepath)
        elevation <- raster::raster(tile)
        ukgrid = "+init=epsg:27700"
        UKprojected <- raster::projectRaster(elevation, crs= ukgrid)
        raster::writeRaster(UKprojected, filename="UK_terrain.tif", format="GTiff", overwrite=TRUE)
}
