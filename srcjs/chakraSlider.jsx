import { reactShinyInput } from "reactR";
import {
  ChakraProvider,
  CSSReset,
  Box,
  Flex,
  NumberInput,
  NumberInputField,
  NumberInputStepper,
  NumberIncrementStepper,
  NumberDecrementStepper,
  Slider,
  SliderTrack,
  SliderFilledTrack,
  SliderThumb
} from "@chakra-ui/core";
import theme from "./chakra"
import { IconContext } from "react-icons";
import { FaRegDotCircle, FaArrowsAltH } from "react-icons/fa";
import { MdRadioButtonChecked, MdRadioButtonUnchecked } from "react-icons/md";
import ReactHtmlParser from "react-html-parser";

const createLabel = (label) => {
  let html = null;
  if(label !== null){
    html = ReactHtmlParser(decodeURI(label));
  }
  return html;
}

const createThumb = (icon, color, size) => {
    let thumb = null;
    if(icon !== null){
      switch(icon) {
        case "dotCircle":
          icon = <FaRegDotCircle />;
          break;
        case "arrows":
          icon = <FaArrowsAltH />;
          break;
        case "bigdotCircle":
          icon = <MdRadioButtonChecked />;
          break;
        case "circle":
          icon = <MdRadioButtonUnchecked />;
          break;
      }
//      thumb = <Box color={color} as={icon} />
      thumb =
        <IconContext.Provider
          value = {{ color: color, size: size}}
        >
          <div>
            {icon}
          </div>
        </IconContext.Provider>;
    }
    return thumb;
  }

class Widget extends React.PureComponent {

  constructor(props) {
    super(props);
    this.state = {
      value: this.props.value
    };
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(value){
    this.setState({value: value});
    this.props.setShinyValue(parseFloat(value));
  }

  componentDidUpdate(prevProps, prevState) {
    if(this.props.value > this.props.max || this.props.value < this.props.min){
      this.props.setShinyValue(parseFloat(prevProps.value));
    }
  }

  render() {
    return (
      <ChakraProvider theme = {theme}>
        <CSSReset />
        {createLabel(this.props.label)}
        <Flex>
          <NumberInput
            min = {this.props.min}
            max = {this.props.max}
            step = {this.props.step}
            size = {this.props.size}
            maxW = {this.props.numberInputOptions.width}
            mr = {this.props.gap}
            value = {this.state.value}
            onChange = {this.handleChange}
          >
            <NumberInputField
              type = "number"
              fontSize = {this.props.numberInputOptions.fontSize}
              color = {this.props.numberInputOptions.fontColor}
              borderColor = {this.props.numberInputOptions.borderColor}
              focusBorderColor = {this.props.numberInputOptions.focusBorderColor}
              borderWidth = {this.props.numberInputOptions.borderWidth}
            />
            <NumberInputStepper>
              <NumberIncrementStepper
                bg = {this.props.numberInputOptions.stepperColor[0]}
              />
              <NumberDecrementStepper
                bg = {this.props.numberInputOptions.stepperColor[1]}
              />
            </NumberInputStepper>
          </NumberInput>
          <Slider
            flex = "1"
            min = {this.props.min}
            max = {this.props.max}
            step = {this.props.step}
            size = {this.props.size}
            value = {this.state.value}
            onChange = {this.handleChange}
          >
            <SliderTrack
              bg = {this.props.trackColor[1]}
            >
              <SliderFilledTrack
                bg = {this.props.trackColor[0]}
              />
            </SliderTrack>
            <SliderThumb
              fontSize = "sm"
              width = {this.props.thumbOptions.width}
              height = {this.props.thumbOptions.height}
              bg = {this.props.thumbOptions.color}
              borderColor = {this.props.thumbOptions.borderColor}
              borderWidth = {this.props.thumbOptions.borderWidth}
            >
              {createThumb(
                this.props.thumbOptions.icon,
                this.props.thumbOptions.iconColor,
                this.props.thumbOptions.iconSize
              )}
            </SliderThumb>
          </Slider>
        </Flex>
      </ChakraProvider>
    );
  }
}

const Input = ({ configuration, value, setValue }) => {
  return (
    <Widget
      label = {configuration.label}
      setShinyValue = {setValue}
      value = {value}
      min = {configuration.min}
      max = {configuration.max}
      step = {configuration.step}
      size = {configuration.size}
      numberInputOptions = {configuration.numberInputOptions}
      trackColor = {configuration.trackColor}
      thumbOptions = {configuration.thumbOptions}
      gap = {configuration.gap}
    />
  );
};

reactShinyInput(".chakraSlider", "shinyChakraSlider.chakraSlider", Input);
