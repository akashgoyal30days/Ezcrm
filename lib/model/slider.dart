import 'package:flutter/cupertino.dart';
import 'package:zoho_crm_clone/constants/constants.dart';

class Slider {
  final String sliderImageUrl;
  final String sliderHeading;
  final String sliderSubHeading;

  Slider(
      {@required this.sliderImageUrl,
      @required this.sliderHeading,
      @required this.sliderSubHeading});
}

final sliderArrayList = [
    Slider(
        sliderImageUrl: 'assets/images/slider_1.png',
        sliderHeading: Constants.SLIDER_HEADING_1,
        sliderSubHeading: Constants.SLIDER_DESC1),
    Slider(
        sliderImageUrl: 'assets/images/slider_2.png',
        sliderHeading: Constants.SLIDER_HEADING_2,
        sliderSubHeading: Constants.SLIDER_DESC2),
    Slider(
        sliderImageUrl: 'assets/images/slider_3.png',
        sliderHeading: Constants.SLIDER_HEADING_3,
        sliderSubHeading: Constants.SLIDER_DESC3),
  Slider(
      sliderImageUrl: 'assets/images/slider_4.png',
      sliderHeading: Constants.SLIDER_HEADING_4,
      sliderSubHeading: Constants.SLIDER_DESC4),
  Slider(
      sliderImageUrl: 'assets/images/slider_5.png',
      sliderHeading: Constants.SLIDER_HEADING_5,
      sliderSubHeading: Constants.SLIDER_DESC5),
  Slider(
      sliderImageUrl: 'assets/images/slider_6.png',
      sliderHeading: Constants.SLIDER_HEADING_6,
      sliderSubHeading: Constants.SLIDER_DESC6),
  Slider(
      sliderImageUrl: 'assets/images/slider_7.png',
      sliderHeading: Constants.SLIDER_HEADING_7,
      sliderSubHeading: Constants.SLIDER_DESC7),
  Slider(
      sliderImageUrl: 'assets/images/slider_8.png',
      sliderHeading: Constants.SLIDER_HEADING_8,
      sliderSubHeading: Constants.SLIDER_DESC8),
  Slider(
      sliderImageUrl: 'assets/images/slider_9.png',
      sliderHeading: Constants.SLIDER_HEADING_9,
      sliderSubHeading: Constants.SLIDER_DESC9),
  Slider(
      sliderImageUrl: 'assets/images/slider_10.png',
      sliderHeading: Constants.SLIDER_HEADING_10,
      sliderSubHeading: Constants.SLIDER_DESC10),

  ];
