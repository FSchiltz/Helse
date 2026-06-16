import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/services/swagger/generated_code/helseapi.enums.swagger.dart';

enum StateType { events, metric, eventValue, metricGroup }

class ColorValue {
  final String key;
  final Color value;
  final StateType type;

  ColorValue({required this.key, required this.value, required this.type});
}

class ThemeHelper {
  final Map<StateType, Map<String, Color>> colors = {};

  Timer? _saveTimer;

  bool isDark(BuildContext context) {
    final InterfaceTheme theme = Dependencies.logics.settings.themebloc.state;
    if (theme == InterfaceTheme.system) {
      var brightness = MediaQuery.of(context).platformBrightness;
      return brightness == Brightness.dark;
    }

    return theme == InterfaceTheme.dark;
  }

  static Color randomColor() {
    var r = Random();
    return Color.fromRGBO(
      r.nextInt(155) + 100,
      r.nextInt(155) + 100,
      r.nextInt(155) + 100,
      1,
    );
  }

  Color stateColor(String state, StateType type, BuildContext context) {
    var group = colors[type];
    group ??= colors[type] = {};

    Color color;
    if (group.containsKey(state)) {
      color = group[state]!;
    } else {
      group[state] = color = randomColor();
      _save();
    }

    if (isDark(context)) return color;

    final double coeff = 1;
    return Color.from(
      red: (color.r * coeff).clamp(0, 1),
      green: (color.g * coeff).clamp(0, 1),
      blue: (color.b * coeff).clamp(0, 1),
      alpha: 1,
    );
  }

  void loadColors(Map<StateType, Map<String, Color>> map) {
    colors.clear();
    colors.addEntries(map.entries);
  }

  Future<void> _save() async {
    final timer = _saveTimer;
    if (timer != null) {
      timer.cancel();
    }

    _saveTimer = Timer(
      Duration(milliseconds: 100),
      () => Dependencies.logics.settings.setColors(colors, toServer: false),
    );
  }
}
