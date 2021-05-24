part of 'services.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double defaultSize;
  static Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }

}

//Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double cscreenHeight = SizeConfig.screenHeight;
  return (inputHeight / 812) * cscreenHeight;
}

//Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double cscreenWidth = SizeConfig.screenWidth;
  return (inputWidth / 375.0) * cscreenWidth;
}