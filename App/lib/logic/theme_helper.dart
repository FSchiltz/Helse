import 'dart:math';
import 'dart:ui';

class ThemeHelper {
  final Map<String, Color> colors = {};

  Color stateColor(String state) {
    if (colors.containsKey(state)) {
      return colors[state]!;
    } else {
      var r = Random();
      var color = Color.fromRGBO(r.nextInt(55) + 100, r.nextInt(105) + 150, r.nextInt(105) + 100, 1);
      colors[state] = color;
      return color;
    }
  }
}
