import 'package:flutter/material.dart';

class UIConstants {
  static const int displaySmall = 400;
  static const int displaymedium = 800;
  static const int displayLarge = 1080;

  static const double formPad = 14;
  static const double headerPad = 24;
  static const double tablePad = 4;
  static const double textPad = 4;

  static const double icon = 32;
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
