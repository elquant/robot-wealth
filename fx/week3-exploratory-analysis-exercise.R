library(quantmod)
library(glue)
options(digits.secs=3)

# set up file paths to tick data downloaded from Darwinex
path <- DATA_FOLDER
ticks_file <- "EURUSD_2019.csv"

# read in data  
ticks <-  read.csv(file.path(path, ticks_file),
                   header = TRUE, sep = ",", 
                   stringsAsFactors = FALSE)


# convert timestamp to posix
ticks[, "Date"] <- as.POSIXct(ticks[, "Date"], tz="GMT")

# convert to xts
ticks <- as.xts(ticks[, 2:3], order.by = ticks$Date)

# fill forward to estimate "continuous" spread
ticks_ffwd <- na.locf(ticks)

# calculate "continuous" spread
spread <- ticks_ffwd$ASK - ticks_ffwd$BID
spread[spread<0] <- 0

# plot subset of raw bid asks
plot.xts(ticks['2019-04-05 00/2019-04-05 01'], type='s')

# plot subset of estimated "continuous" bid-asks
plot.xts(ticks_ffwd['2019-04-05 00/2019-04-05 01'], type='s')

# plot subset of estimated "continuous" spread
plot.xts(spread['2019-04-05 00/2019-04-05 01'], type='s')

### Sunday Open ###

plot.xts(ticks['2019-03-31'], type='s')