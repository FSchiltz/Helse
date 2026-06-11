import 'dart:math';

import 'package:flutter/material.dart';

enum StateType {
  event,
  eventValue,
  metric,
  metricGroup,
  metricValue,
}

class ThemeHelper {
  final Map<String, Color> colors = {};


  Color stateColor(String state, StateType type, BuildContext context) {
    if (colors.containsKey(state)) {
      return colors[state]!;
    } else {
      var r = Random();
      var color = Color.fromRGBO(
        r.nextInt(155) + 100,
        r.nextInt(155) + 100,
        r.nextInt(155) + 100,
        1,
      );
      colors[state] = color;

      var brightness = MediaQuery.of(context).platformBrightness;
      if(brightness == Brightness.dark)      return color;

      return Color.from(red: color.r /2, green: color.g/ 2, blue: color.b /2, alpha: 1);
    }
  }
}
