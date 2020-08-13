#' @importFrom grDevices col2rgb rgb
#' @noRd
color2hex <- function(color){
  if(is.null(color)) return(NULL)
  RGB <- col2rgb(color)[,1]
  rgb(RGB["red"], RGB["green"], RGB["blue"], maxColorValue = 255)
}

