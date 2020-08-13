#' Options for the thumb of a chakra slider
#' @description Create a list of options to be passed to \code{thumbOptions}
#' in \code{\link{chakraSliderInput}}
#'
#' @param width width of the thumb, e.g. \code{"30px"}
#' @param height height of the thumb, e.g. \code{"30px"}
#' @param color color of the thumb
#' @param borderColor color of the border of the thumb
#' @param borderWidth width of the border of the thumb, e.g.
#' \code{"3px"} or \code{"thin"}
#' @param icon an icon for the thumb, can be \code{"circle"},
#' \code{"dotCircle"}, \code{"bigdotCircle"} or \code{"arrows"}
#' @param iconColor color of the icon
#' @param iconSize size of the icon, e.g. \code{"10px"} or \code{"3em"}
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

#' Chakra slider
#' @description This creates a chakra slider in the Shiny UI. A chakra slider
#' has two elements: a number input and a slider, which are linked together.
#'
#' @param inputId the input slot that will be used to access the value
#' @param label the label for the widget; this can be some HTML code
#' @param value initial value
#' @param min minimum allowed value
#' @param max maximum allowed value
#' @param step stepping interval to use when adjusting the value
#' @param width width of the widget, e.g. \code{"50\%"} or \code{"200px"}
#' @param size size of the widget, can be \code{"sm"} (small),
#' \code{"md"} (medium) or \code{"lg"} (large)
#' @param numberInputOptions list of options for the number input;
#' see \code{\link{numberInputOptions}}
#' @param trackColor color(s) for the track of the slider, can be
#' a single color or a vector of two colors, one for the left side
#' and one for the right side
#' @param thumbOptions list of options for the thumb of the slider;
#' see \code{\link{thumbOptions}}
#' @param gap size of the gap between the number input and the slider,
#' e.g. \code{"3px"} or \code{"5\%"}
#'
#' @importFrom reactR createReactShinyInput
#' @importFrom htmltools htmlDependency tags
#' @importFrom shiny validateCssUnit
#' @importFrom utils packageVersion URLencode
#' @export
#'
#' @examples library(shiny)
#' library(shinyChakraSlider)
#'
#' ui <- fluidPage(
#'   br(),
#'   chakraSliderInput(
#'     "slider",
#'     label = tags$span(
#'       style = "font-size: 20px; font-style: italic; color: darkred;",
#'       "Chakra Slider"
#'     ),
#'     value = 5, min = 0, max = 10, step = 0.5,
#'     width = "50%", size = "lg",
#'     numberInputOptions = numberInputOptions(
#'       width = "25%",
#'       fontSize = "15px",
#'       fontColor = "navyblue",
#'       borderColor = "gold",
#'       borderWidth = "medium",
#'       focusBorderColor = "navyblue",
#'       stepperColor = c("palegreen", "lightpink")
#'     ),
#'     trackColor = c("lightpink2", "springgreen"),
#'     thumbOptions = thumbOptions(
#'       width = "30px",
#'       height = "30px",
#'       color = "white",
#'       borderColor = "darkblue",
#'       borderWidth = "8px",
#'       icon = "circle",
#'       iconSize = "2.5em"
#'     )
#'   ),
#'   br(),
#'   tags$div(
#'     style = "width: 50%;",
#'     wellPanel(
#'       style =
#'         "vertical-align: top; width: 150px; padding: 11.5px; float: left;",
#'       textOutput("value"),
#'     ),
#'     tags$div(
#'       style = "float: right;",
#'       actionButton("update", "Update value", class = "btn-danger btn-lg")
#'     )
#'   )
#' )
#'
#' server <- function(input, output, session){
#'
#'   output[["value"]] <- renderText({
#'     paste0("Value: ", input[["slider"]])
#'   })
#'
#'   observeEvent(input[["update"]], {
#'     updateChakraSliderInput(session, "slider", value = 8)
#'   })
#'
#' }
#'
#' if(interactive()){
#'   shinyApp(ui, server)
#' }
chakraSliderInput <- function(
  inputId,
  label = NULL,
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
      version = as.character(packageVersion("shinyChakraSlider")),
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
      gap = validateCssUnit(gap),
      slider = TRUE
    ),
    container = function(...){
      htmltools::tags$div(
        style = sprintf("width: %s;", validateCssUnit(width)),
        ...
      )
    }
  )
}

#' Update a chakra slider
#' @description Update the value of a chakra slider.
#'
#' @param session the Shiny session object
#' @param inputId the id of the chakra slider to update
#' @param value the new value of the chakra slider
#'
#' @export
updateChakraSliderInput <- function(session, inputId, value){
  session$sendInputMessage(inputId, list(value = value))
}
