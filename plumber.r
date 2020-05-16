# plumber.R

#' Echo the parameter that was sent in
#' @param msg The message to echo back.
#' @get /root
function(msg=""){
  list(msg = paste0("The message is: '", msg, "'"))
}
