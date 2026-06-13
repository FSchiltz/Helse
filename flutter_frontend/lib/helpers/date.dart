import 'package:flutter/material.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/services/swagger/generated_code/helseapi.enums.swagger.dart';
import 'package:intl/intl.dart';

class DateHelper {
  static DateTimeRange now() {
    var now = endOfToday();
    return DateTimeRange(start: now.subtract(Duration(days: 1)), end: now);
  }

  static String format(
    DateTime? date, {
    bool? second,
    required BuildContext context,
  }) {
    if (date == null) return "";
    var tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();

    DateFormat dateTimeFormat = DateFormat.yMMMMd(tag);
    if (second == true) {
      dateTimeFormat = dateTimeFormat.add_jms();
    } else {
      dateTimeFormat = dateTimeFormat.add_jm();
    }
    return dateTimeFormat.format(date.toLocal());
  }

  static String formatMonth(DateTime? date, {required BuildContext context}) {
    if (date == null) return "";
    var tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();
    DateFormat dateTimeFormat = DateFormat.yMMM(tag);
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
      case DatePreset.week:
        return currentWeek();
      case DatePreset.month:
        return currentMonths();
      case DatePreset.trimestre:
        return currentMonths(count: 3);
      case DatePreset.halfyear:
        return currentMonths(count: 6);
      case DatePreset.year:
        return currentWeek(count: 365);
      case DatePreset.yeartodate:
        return yearToDate();
      default:
        return now();
    }
  }

  static DateTimeRange currentWeek({int count = 7}) {
    var now = endOfToday();

    var end = now;
    var start = end.subtract(Duration(days: count));

    return DateTimeRange(start: start, end: end);
  }

  static DateTime endOfToday() {
    var now = DateTime.now();

    return DateTime(
      now.year,
      now.month,
      now.day,
      0,
      0,
      0,
    ).add(Duration(days: 1));
  }

  static DateTimeRange currentMonths({int count = 1}) {
    var now = endOfToday();

    var end = now;
    var start = end.subtract(Duration(days: 30 * count));

    return DateTimeRange(start: start, end: end);
  }

  static DateTimeRange yearToDate() {
    var now = endOfToday();

    var start = DateTime(now.year, 1, 1);
    var end = now.add(Duration(days: 1));

    return DateTimeRange(start: start, end: end);
  }

  static String formatDuration(Duration duration, AppLocalizations locale) {
    if (duration.inMinutes < 1) {
      return _seconds(duration);
    }

    if (duration.inHours < 1) {
      var minutes = duration - Duration(hours: duration.inHours);
      return "${minutes.inMinutes}m ${_seconds(duration)}";
    }

    if (duration.inDays < 1) {
      return _hours(duration);
    }

    return '${duration.inDays} ${locale.days} ${_hours(duration)}';
  }

  static String _seconds(Duration duration) {
    var seconds = duration - Duration(minutes: duration.inMinutes);
    return "${seconds.inSeconds}s";
  }

  static String _minutes(Duration duration) {
    var minutes = duration - Duration(hours: duration.inHours);
    return "${minutes.inMinutes}m";
  }

  static String _hours(Duration duration) {
    var hours = duration - Duration(days: duration.inDays);
    return '${hours.inHours}h ${_minutes(duration)}';
  }

  static DateTime max(DateTime date1, DateTime date2) {
    if (date1.isAfter(date2)) {
      return date1;
    }
    return date2;
  }

  static DateTime min(DateTime date1, DateTime date2) {
    if (date1.isAfter(date2)) {
      return date2;
    }

    return date1;
  }
}
