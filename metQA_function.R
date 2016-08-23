#set working directory
setwd('C:\\R_Scripts\\metQA\\function_test')

#load libraries
library(worldmet)

# user add site1 code and site2 code files, including the path to the file e.g. 
# filleR('031600-99999', '31660-99999', 2015)

filleR <- function(site1, site2, year){
  #this downloads the data and calls the file dat
  site1_data <- importNOAA(code = site1, year = year)
  site2_data <-importNOAA(code = site2, year = year)
  
  #write csv file for met data
  write.csv(site1_data, file= paste0(site1, year, ".csv"))
  write.csv(site2_data, file= paste0(site2, year, ".csv"))
  
  #export as ADMS file
  exportADMS(site1_data,out = paste0(site1, year, "_raw.met"), interp = FALSE)
  exportADMS(site2_data,out = paste0(site2, year, "_raw.met"), interp = FALSE)
  
  # from here copy the other site into the original site 
  #take cloud cover from one dat file to another
  site1_data$cl_for_filling <- site2_data$cl
  
  # interpolate across the gaps in the first site cloud
  site1_data$cl_interpolated <- na.approx(object = site1_data$cl, maxgap = 5, rule =2)
  
  # interpolate across the gaps in the second site which was imported into the first
  site1_data$cl_interpolated_2 <- na.approx(object = site1_data$cl_for_filling, maxgap = 5, rule =2)
  
  # set NAs in the first site
  site1_data$cl_interpolated[is.na(site1_data$cl_interpolated)] <- "999"
  
  # where the first site is 999 use the value from the interpolated second site
  site1_data$cl_filled <- ifelse(site1_data$cl_interpolated =="999", site1_data$cl_interpolated_2, site1_data$cl_interpolated)
  
    #export csv of filled data
  write.csv(site1_data, file = paste0(site1, "_", year, "_final.csv"))

}

filleR('031660-99999', '031600-99999', 2015)