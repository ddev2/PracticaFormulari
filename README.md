# Read-World-Fertility-Survey-file

This is a R function for converting a World Fertility Survey DAT file into a R data.frame.
This code is meant only for Individual standard recode data (Original WFS format).
It uses two files: the data and the dictionary files.
For example for Colombia 1976, this should be cosr02.dat and cosr02.dct.

This code should be run inside RStudio (it uses its API to present a dialog box).
The only change you may need to do is to provide the position of the household ID and of the woman line number in the first variable (V001), if you need to use that information later.

For example for reading the Colombia DAT file, the calling code is:

``` r
colombia <- readWFS(c(c(6, 10), c(11, 12)))
```
The household ID is at position 6 to 10 and the woman line number in the household file is at position 11 to 12 of the V001 variable.<br>

The ReadWFS automatically creates a Rdat file, in the same directory than the original WFS DAT file, which contains a data.frame with the converted WFS file.<br>

<B>colombia</B> is a vector which contains the path to the directory and the name of the R file. If you want to change to this directory, simply enter in RStudio:
``` r
setwd(colombia[1])
```
If you want to load the data.frame in RStudio, enter:
``` r
load(paste(colombia[2], ".Rdat", sep="")) 
```
