
# plumber.r

#' Echo the parameter that was sent in
#' @param msg The message to echo back.
#' @get /echo
function(msg=""){
  list(msg = paste0("The message is: '", msg, "'"))
}

#* Plot a histogram
#* @param msg The message to echo back.
#* @get /plot
#* @png

function(Province="", Country=""){
 source("CanadianProvincesRplot.R")
 plot(PlotRwithconfint(Province, Country))
 #png(filename = "mtcars.png")
# list(msg = paste0("The message is: '", msg, "'"))
}

#* @assets ./static /
list()