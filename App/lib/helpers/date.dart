import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateHelper {
  static DateTimeRange now() {
    var now = DateTime.now();
    return DateTimeRange(start: DateTime(now.year, now.month, now.day), end: DateTime(now.year, now.month, now.day, 23, 59, 59));
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
}
