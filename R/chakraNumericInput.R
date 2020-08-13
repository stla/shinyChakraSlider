#' Options for chakra number input or for the number input of a chakra slider
#' @description Create a list of options to be passed to
#'   \code{numberInputOptions} in \code{\link{chakraNumberInput}} or
#'   \code{\link{chakraSliderInput}}.
#'
#' @param width width of the number input, e.g. \code{"100px"} or \code{"20\%"}
#' @param fontSize font size of the displayed value, e.g. \code{"15px"}
#' @param fontColor color of the displayed value
#' @param borderColor color of the border of the number input
#' @param focusBorderColor color of the border of the number input on focus
#' @param borderWidth width of the border of the number input,
#'   e.g. \code{"3px"} or \code{"medium"}
#' @param stepperColor color(s) of the steppers, can be a single color
#'   or a vector of two colors, one for each stepper (increment and decrement)
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

#' Chakra number input
#' @description This creates a number input in the Shiny UI.
#'
#' @param inputId the input slot that will be used to access the value
#' @param label the label for the widget; this can be some HTML code
#' @param value initial value
#' @param min minimum allowed value
#' @param max maximum allowed value
#' @param step stepping interval to use when adjusting the value
#' @param size size of the widget, can be \code{"sm"} (small),
#'   \code{"md"} (medium) or \code{"lg"} (large)
#' @param numberInputOptions list of options for the number input;
#'   see \code{\link{numberInputOptions}}
#'
#' @importFrom reactR createReactShinyInput
#' @importFrom htmltools htmlDependency tags
#' @importFrom shiny validateCssUnit
#' @export
chakraNumberInput <- function(
  inputId,
  label = NULL,
  value,
  min,
  max,
  step = NULL,
#  width = "100%",
  size = "md",
  numberInputOptions = list())
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
      label = if(!is.null(label))
        URLencode(as.character(tags$label(class = "control-label", label))),
      min = min,
      max = max,
      step = step,
      size = match.arg(size, c("sm", "md", "lg")),
      numberInputOptions = if(is.null(numberInputOptions$width)){
        append(list(width = "100%"), numberInputOptions)
      }else{
        numberInputOptions
      },
      slider = FALSE
    ),
    container = htmltools::tags$div
    # container = function(...){
    #   htmltools::tags$div(
    #     style = sprintf("width: %s;", validateCssUnit(width)),
    #     ...
    #   )
    # }
  )
}

#' Update a chakra number input
#' @description Update the value of a chakra number input.
#'
#' @param session the Shiny session object
#' @param inputId the id of the chakra number input to update
#' @param value the new value of the chakra number input
#'
#' @export
updateChakraNumberInput <- function(session, inputId, value){
  session$sendInputMessage(inputId, list(value = value))
}
