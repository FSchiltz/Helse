import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateHelper {
  static DateTimeRange now() {
    var now = DateTime.now();
    return DateTimeRange(start: DateTime(now.year, now.month, now.day), end: DateTime(now.year, now.month, now.day, 23, 59, 59));
  }

  static String format(DateTime? date, {bool? second}) {
    if (date == null) return "";

    DateFormat dateTimeFormat = DateFormat.yMMMMd();
    if (second == true) {
      dateTimeFormat = dateTimeFormat.add_jms();
    } else {
      dateTimeFormat = dateTimeFormat.add_jm();
    }
    return dateTimeFormat.format(date);
  }
}
