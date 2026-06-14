import 'dart:math';

import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';

enum StateType { events, metric, eventValue, metricGroup }

class ColorValue {
  final String key;
  final Color value;
  final StateType type;

  ColorValue({required this.key, required this.value, required this.type});
}

class ThemeHelper {
  final Map<StateType, Map<String, Color>> colors = {};

  Color stateColor(String state, StateType type, BuildContext context) {
    var group = colors[type];
    group ??= colors[type] = {};

    if (group.containsKey(state)) {
      return group[state]!;
    } else {
      var r = Random();
      var color = Color.fromRGBO(
        r.nextInt(155) + 100,
        r.nextInt(155) + 100,
        r.nextInt(155) + 100,
        1,
      );
      group[state] = color;

      // trigger a saving of the new color
      // TODO use a thread safe approach
      Dependencies.logics.settings.setColors(colors, toServer: false);

      var brightness = MediaQuery.of(context).platformBrightness;
      if (brightness == Brightness.dark) return color;

      return Color.from(
        red: color.r / 2,
        green: color.g / 2,
        blue: color.b / 2,
        alpha: 1,
      );
    }
  }

  void setColors(Map<StateType, Map<String, Color>> map) {
    colors.addEntries(map.entries);
  }
}
