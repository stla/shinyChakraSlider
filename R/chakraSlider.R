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
  borderWidth = NULL,
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
    borderWidth = if(!is.null(borderWidth)){
      if(borderWidth %in% c("medium", "thick", "thin")){
        borderWidth
      }else{
        validateCssUnit(borderWidth)
      }
    },
    icon = icon,
    iconColor = color2hex(iconColor),
    iconSize = validateCssUnit(iconSize)
  )
}

#' Options for the number input of \code{chakraSliderInput}
#' @description Create a list of options to be passed to
#' \code{numberInputOptions} in \code{chakraSliderInput}.
#'
#'
#' @importFrom shiny validateCssUnit
#' @export
numberInputOptions <- function(
  width = NULL,
  fontSize = NULL,
  fontColor = NULL,
  borderColor = NULL,
  focusBorderColor= NULL,
  borderWidth = NULL,
  stepperColor = NULL
){
  list(
    width = validateCssUnit(width),
    fontSize = validateCssUnit(fontSize),
    fontColor = color2hex(fontColor),
    borderColor = color2hex(borderColor),
    focusBorderColor = color2hex(focusBorderColor),
    borderWidth = if(!is.null(borderWidth)){
      if(borderWidth %in% c("medium", "thick", "thin")){
        borderWidth
      }else{
        validateCssUnit(borderWidth)
      }
    },
    stepperColor = if(!is.null(stepperColor)){
      if(length(stepperColor) == 1L) stepperColor <- rep(stepperColor, 2L)
      lapply(stepperColor, color2hex)
    }else{
      list(NULL, NULL)
    }
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
chakraSliderInput <- function(
  inputId,
  value,
  min,
  max,
  step = NULL,
  width = "100%",
  size = "md",
  numberInputOptions = list(),
  trackColor = NULL,
  thumbOptions = list(),
  gap = "2rem")
{
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
      min = min,
      max = max,
      step = step,
      size = match.arg(size, c("sm", "md", "lg")),
      numberInputOptions = if(is.null(numberInputOptions$width)){
        append(list(width = sprintf("calc(%s / 4)", width)), numberInputOptions)
      }else{
        numberInputOptions
      },
      trackColor = if(!is.null(trackColor)){
        colors <- lapply(trackColor, color2hex)
        if(length(colors) == 1L) colors <- append(colors, list(NULL))
        colors
      }else{
        list(NULL, NULL)
      },
      thumbOptions = thumbOptions,
      gap = validateCssUnit(gap)
    ),
    container = function(...){
      htmltools::tags$div(
        style = sprintf("width: %s;", validateCssUnit(width)),
        ...
      )
    }
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
