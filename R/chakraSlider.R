color2hex <- function(color){
  if(is.null(color)) return(NULL)
  RGB <- col2rgb(color)[,1]
  rgb(RGB["red"], RGB["green"], RGB["blue"], maxColorValue = 255)
}

#' Options for the thumb of \code{chakraSliderInput}
#' @description Create a list of options to be passed to \code{thumbOptions}
#' in \code{chakraSliderInput}.
#'
#'
#' @importFrom shiny validateCssUnit
#' @export
thumbOptions <- function(
  width = NULL,
  height = NULL,
  color = NULL,
  borderColor = NULL,
  icon = NULL,
  iconColor = NULL,
  iconSize = NULL
){
  icon <- if(!is.null(icon)){
    match.arg(icon, c("circle", "dotCircle", "bigdotCircle", "arrows"))
  }
  list(
    width = validateCssUnit(width),
    height = validateCssUnit(height),
    color = color2hex(color),
    borderColor = color2hex(borderColor),
    icon = icon,
    iconColor = color2hex(iconColor),
    iconSize = validateCssUnit(iconSize)
  )
}

#' <Add Title>
#'
#' <Add Description>
#'
#' @importFrom shiny restoreInput
#' @importFrom reactR createReactShinyInput
#' @importFrom htmltools htmlDependency tags
#'
#' @export
chakraSliderInput <- function(inputId, value, thumbOptions = list()){
  reactR::createReactShinyInput(
    inputId,
    "chakraSlider",
    htmltools::htmlDependency(
      name = "chakraSlider-input",
      version = "1.0.0",
      src = "www/shinyChakraSlider/chakraSlider",
      package = "shinyChakraSlider",
      script = "chakraSlider.js"
    ),
    default = value,
    configuration = list(
      thumbOptions = thumbOptions
    ),
    htmltools::tags$div
  )
}

#' <Add Title>
#'
#' <Add Description>
#'
#' @export
updateChakraSliderInput <- function(session, inputId, value, configuration = NULL) {
  message <- list(value = value)
  if (!is.null(configuration)) message$configuration <- configuration
  session$sendInputMessage(inputId, message);
}
