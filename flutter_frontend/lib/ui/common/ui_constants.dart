import 'package:flutter/material.dart';

class UIConstants {
  static int displaySmall = 400;
  static int displaymedium = 800;
  static int displayLarge = 1080;
}

class UIHelpers {
  static bool isMobile(BuildContext context) {
    var media = MediaQuery.of(context);
    double screenWidth = media.size.width;
    return screenWidth < UIConstants.displaymedium;
  }

  static double screenWidth(BuildContext context) {
    var media = MediaQuery.of(context);
    return media.size.width;
  }
}
