import 'package:helse/services/swagger/generated_code/helseapi.enums.swagger.dart';

class Translation {
  static String get(DatePreset value) {
    switch (value) {
      case DatePreset.week:
        return '7 days';
      case DatePreset.month:
        return '30 days';
      case DatePreset.trimestre:
        return '3 Months';
      case DatePreset.halfyear:
        return '6 Months';
      case DatePreset.year:
        return '1 Year';
      case DatePreset.yeartodate:
        return 'Year to date';

      default:
        return 'Today';
    }
  }
}
