# Read-World-Fertility-Survey-file

This is a R function for converting a World Fertility Survey DAT file into a R data.frame.
This code is meant only for Individual standard recode data (Original WFS format).
It uses two files: the data and the dictionnary files.
For example for Colombia 1976, this should be cosr02.dat and cosr02.dct.

This code should be run inside RStudio (it uses its API to present a dialog box).
The only change you may need to do is to provide the position of the household ID and of the woman line number in the first variable (V001).

For example for reading the Colombia DAT file, the calling code is:

colombia <- readWFS(c(c(6, 10), c(11, 12)), exportToExcel=TRUE)

setwd(colombia[1])

load(paste(colombia[2], ".Rdat", sep="")) 
