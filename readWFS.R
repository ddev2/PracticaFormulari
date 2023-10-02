#### Read WFS file by Daniel ####

readWFS <- function(posHousehold=NULL, exportToSPSS=FALSE, exportToExcel=FALSE) {
  #posHousehold contains the household number and the line number of the woman in format c(start, end)
  #for example posHousehold <- c(c(6, 10), c(11, 12))
  library2 ("expss")

  ok <- rstudioapi::showQuestion("Choose a WFS dat file",
                                 "(the dct file should be in the same directory)",
                                 ok = "Ok", cancel = "Cancel")
  
  if (!ok) stop("stopping...")
  
  dataFileName <- ""
  dataFileName <- file.choose()
  if (dataFileName == "") stop ("No file chosen")
  dictFileName <- paste (substring (dataFileName, 1, nchar(dataFileName)-4), ".dct", sep="")
  
  dataFile <- ""
  dataFile <- readLines(dataFileName)
  nWomen <- length(dataFile)
  if (nWomen <= 1) stop ("No data file")
  
  dictFile <- ""
  dictFile <- readLines(dictFileName)
  nLinesDict <- length(dictFile)
  if (nLinesDict <= 1) stop ("No dictionnary file")
  wfs_df <- data.frame(ln=seq(1,nWomen))
  if (!is.null (posHousehold)) {
    wfs_df$HD <- rep(0, nWomen)
    wfs_df$WLN <- rep(0, nWomen)
  }
  for (lineNumber in (1:nLinesDict)) {
    #skip comments
    if (substring (dictFile [lineNumber], 1, 1) %in% c("$", "(", "%", "*", ">")) {next}
    if (substring (dictFile [lineNumber], 1, 1) == " ") {
      #a value label for variable 'nameVariable' created just before
      #   36-39    VALUE              THE CODE BEING DEFINED.                *00125000
      #   44-63    LABEL              UP TO 20 CHARACTERS, LEFT JUSTIFIED.   *00126000
      aValue <- as.numeric(substring (dictFile [lineNumber], 36, 39))
      aLabel <- trimws (substring (dictFile [lineNumber], 44, 63))
      aVec <- c()
      aVec[aLabel] <- aValue
      add_val_lab(wfs_df[nameVariable]) = aVec
    } else {
      #a new variable
      nameVariable <- trimws (substring (dictFile [lineNumber], 1, 6))
      print (nameVariable)
      startVariable <- as.numeric(substring (dictFile [lineNumber], 10, 13))
      lengthVariable <- as.numeric(substring (dictFile [lineNumber], 15, 16))
      minVariable <- as.numeric(substring (dictFile [lineNumber], 17, 20))
      maxVariable <- as.numeric(substring (dictFile [lineNumber], 21, 24))
      labelVariable <- trimws (substring (dictFile [lineNumber], 36, 65))
      sameLabelsVariable <- trimws (substring (dictFile [lineNumber], 67, 72))
      
      wfs_df[nameVariable] <- rep(0, nWomen)
      wfs_df[nameVariable] <- as.numeric (substring (dataFile, startVariable, startVariable + lengthVariable - 1))
      aList <- list()
      aList [[nameVariable]] <- labelVariable
      wfs_df <- apply_labels(wfs_df, aList)
      if (nchar(sameLabelsVariable) > 0) {
        print(paste("using labels", sameLabelsVariable))
        val_lab(wfs_df[nameVariable]) <- val_lab(wfs_df[sameLabelsVariable])
      }
      if ((nameVariable == "V001") & (!is.null(posHousehold))) {
        wfs_df$HD <- as.numeric (substring (dataFile, posHousehold[1], posHousehold[2]))
        wfs_df$WLN <- as.numeric (substring (dataFile, posHousehold[3], posHousehold[4]))
        aList <- list()
        aList [["HD"]] <- "Household number"
        aList [["WLN"]] <- "Woman line number"
        wfs_df <- apply_labels(wfs_df, aList)
      }
    }
  }
  
  wfs_df$ln <- NULL
  newName <- basename(dataFileName)
  newName <- substring (newName, 1, nchar(newName)-4)
  do.call("<-",list(newName, wfs_df))
  save(list=newName, file=paste (substring (dataFileName, 1, nchar(dataFileName)-4), ".Rdat", sep=""))
  
  if (exportToExcel) {
    library2("writexl")
    write_xlsx(wfs_df, paste (newName, ".xlsx", sep=""))    
  }
  
  return (c(dirname(dataFileName), newName))
}

fileInfo <- readWFS(exportToExcel=TRUE)
setwd(fileInfo[1])
load(paste(fileInfo[2], ".Rdat", sep=""))

colombia <- readWFS(c(c(6, 10), c(11, 12)), exportToExcel=TRUE)
setwd(colombia[1])
load(paste(colombia[2], ".Rdat", sep=""))

mexico <- readWFS(c(c(11, 14), c(15, 16)))
setwd(mexico[1])
load(paste(mexico[2], ".Rdat", sep=""))

portugal <- readWFS(posHousehold=c(c(1, 10), c(11, 14)))
setwd(portugal[1])
load(paste(portugal[2], ".Rdat", sep=""))
