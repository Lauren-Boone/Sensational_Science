import 'package:flutter/widgets.dart'; 

class SizeConfig{
  static MediaQueryData _mediaQueryData; 
  static double screenWidth; 
  static double screenHeight; 
  static double horizontalSize; 
  static double verticalSize; 

  void init(BuildContext context){
    _mediaQueryData = MediaQuery.of(context); 
    screenWidth = _mediaQueryData.size.width; 
    screenHeight = _mediaQueryData.size.height; 
    horizontalSize = screenWidth/100; 
    verticalSize = screenHeight/100; 
  }
}