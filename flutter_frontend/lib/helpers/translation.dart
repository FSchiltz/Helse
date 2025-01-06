import 'package:helse/ui/common/date_range_picker.dart';

class Translation {
  static String get(DatePreset value) {
    switch (value) {
      case DatePreset.today:
        return 'Today';
      case DatePreset.week:
        return '7 days';
      case DatePreset.month:
        return '30 days';
      case DatePreset.trimestre:
        return '3 Months';
      case DatePreset.halfYear:
        return '6 Months';
      case DatePreset.year:
        return '1 Year';
      case DatePreset.yearToDate:
        return 'Year to date';
    }
  }
}
