import 'package:flutter/material.dart';

class DateHelper {
  static DateTimeRange now() {
    var now = DateTime.now();
    return DateTimeRange(start: DateTime(now.year, now.month, now.day), end: DateTime(now.year, now.month, now.day, 23, 59, 59));
  }
}
