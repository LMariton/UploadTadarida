library(stringr)
library(lubridate)
library(XML)

rm(list=ls())

site <- "291604" #identifiant du site sur Vigie-chiro
year <- 2022 #année
pass <- 1 #numéro de passage
point <- "Z18" #point sur le site
recorderID <- "0321" #numéro de série du batlogger
path <- "C:/Users/Lea_Mariton/Desktop/BL20220823"

listFileNames <- list.files(path,full.names = T)
fileNamesNoExt <- str_extract(listFileNames,pattern = ".+(?=\\.[:alpha:]+$)")
fileNamesNoExt <- unique(fileNamesNoExt)
for(fileName in fileNamesNoExt){
  xmlFile <- xmlParse(file=paste0(fileName,".xml"))
  xmlFileNode <- xmlRoot(xmlFile)
  DateTime <- as(xmlFileNode[[which(names(xmlFileNode)=="DateTime")]][[1]],"character")
  dateFile <- paste0(str_sub(DateTime,start = 7,end = 10)
                     ,str_sub(DateTime,start = 4,end = 5)
                     ,str_sub(DateTime,end = 2))
  hourFile <- str_remove_all(str_extract(DateTime,"(?<= ).+$"),":")
  newname <- paste0(path,"/Car",site,"-",year,"-Pass",pass,"-",point,"-"
                    ,recorderID,"-0_",dateFile,"_",hourFile)
  file.rename(from=paste0(fileName,".xml")
              ,to=paste0(newname,".xml"))
  file.rename(from=paste0(fileName,".wav")
              ,to=paste0(newname,".wav"))
}
