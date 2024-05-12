import 'package:flutter/material.dart';
import 'package:helse/ui/common/date_range_picker.dart';
import 'package:intl/intl.dart';

class DateHelper {
  static DateTimeRange now() {
    var now = DateTime.now();
    return DateTimeRange(start: DateTime(now.year, now.month, now.day), end: DateTime(now.year, now.month, now.day + 1));
  }

  static String format(DateTime? date, {bool? second, required BuildContext context}) {
    if (date == null) return "";
    var tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();

    DateFormat dateTimeFormat = DateFormat.yMMMMd(tag);
    if (second == true) {
      dateTimeFormat = dateTimeFormat.add_jms();
    } else {
      dateTimeFormat = dateTimeFormat.add_jm();
    }
    return dateTimeFormat.format(date);
  }

  static String formatDate(DateTime? date, {required BuildContext context}) {
    if (date == null) return "";
    var tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();
    DateFormat dateTimeFormat = DateFormat.yMMMMd(tag);
    return dateTimeFormat.format(date);
  }

  static String formatTime(DateTime? date, {required BuildContext context}) {
    if (date == null) return "";
    var tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();

    DateFormat dateTimeFormat = DateFormat.jms(tag);
    return dateTimeFormat.format(date);
  }

  static DateTimeRange getRange(DatePreset value) {
    switch (value) {
      case DatePreset.today:
        return now();
      case DatePreset.week:
        return currentWeek();
      case DatePreset.month:
        return currentMonths();
      case DatePreset.trimestre:
        return currentMonths(count: 3);
      case DatePreset.halfYear:
        return currentMonths(count: 6);
      case DatePreset.year:
        return currentWeek(count: 365);
      case DatePreset.yearToDate:
      return yearToDate();
    }
  }

  static DateTimeRange currentWeek({int count = 7}) {
    var now = DateTime.now();

    var end = now;
    var start = end.add(Duration(days: -1 * count));

    return DateTimeRange(start: start, end: end);
  }

  static DateTimeRange currentMonths({int count = 1}) {
    var now = DateTime.now();

    var end = now;
    var start = end.add(Duration(days: 30 * -1 * count));

    return DateTimeRange(start: start, end: end);
  }
  
  static DateTimeRange yearToDate() {
       var now = DateTime.now();

    var start = DateTime(now.year, 1, 1);
    var end = now;

    return DateTimeRange(start: start, end: end);
  }
}
