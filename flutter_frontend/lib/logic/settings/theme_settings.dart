import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class ThemeSettings {
  static const _theme = "theme";
  ThemeMode theme;

  ThemeSettings(this.theme);

  // stupid boilerplate code because dart can't decode json
  ThemeSettings.fromJson(dynamic json)
      : theme = ThemeMode.values.firstWhereOrNull((e) => e.name == json[_theme]) ?? ThemeMode.system;

  Map<String, dynamic> toJson() => {
        _theme: theme.name,
      };
}
