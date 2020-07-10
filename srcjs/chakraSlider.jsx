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
          value={{ color: color, size: size}}
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

  render() {
    return (
      <ChakraProvider theme = {theme}>
        <CSSReset />
        <Flex>
          <NumberInput
            maxW = "100px"
            mr = "2rem"
            value = {this.state.value}
            onChange = {this.handleChange}
          >
            <NumberInputField
              type = "number"
              fontSize = "16px"
            />
            <NumberInputStepper>
              <NumberIncrementStepper />
              <NumberDecrementStepper />
            </NumberInputStepper>
          </NumberInput>
          <Slider flex="1" value={this.state.value} onChange={this.handleChange}>
            <SliderTrack>
              <SliderFilledTrack />
            </SliderTrack>
            <SliderThumb
              fontSize = "sm"
              width = {this.props.thumbOptions.width}
              height = {this.props.thumbOptions.height}
              bg = {this.props.thumbOptions.color}
              borderColor = {this.props.thumbOptions.borderColor}
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
      setShinyValue = {setValue}
      value = {value}
      thumbOptions = {configuration.thumbOptions}
    />
  );
};

reactShinyInput(".chakraSlider", "shinyChakraSlider.chakraSlider", Input);
