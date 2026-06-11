import 'dart:math';

import 'package:flutter/material.dart';

enum StateType { event, eventValue, metric, metricGroup, metricValue }

extension HexColor on Color {
  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${a.toByte().toRadixString(16).padLeft(2, '0')}'
      '${r.toByte().toRadixString(16).padLeft(2, '0')}'
      '${g.toByte().toRadixString(16).padLeft(2, '0')}'
      '${b.toByte().toRadixString(16).padLeft(2, '0')}';
}

extension Byte on double {
  int toByte() {
    return (this * 255).round().clamp(0, 255);
  }
}

class ThemeHelper {
  final Map<String, Color> colors = {};

  Color stateColor(String state, StateType type, BuildContext context) {
    var key = "${type.name}_$state";
    if (colors.containsKey(key)) {
      return colors[key]!;
    } else {
      var r = Random();
      var color = Color.fromRGBO(
        r.nextInt(155) + 100,
        r.nextInt(155) + 100,
        r.nextInt(155) + 100,
        1,
      );
      colors[key] = color;

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

  void setColors(Map<String, Color> map) {
    colors.addEntries(map.entries);
  }
}
