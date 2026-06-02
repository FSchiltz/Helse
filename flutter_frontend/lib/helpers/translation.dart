import 'package:flutter/material.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/services/swagger/generated_code/helseapi.enums.swagger.dart';

class Translation {
  static AppLocalizations locale(BuildContext context) {
    var local = AppLocalizations.of(context);
    return local;
  }

  static String get(DatePreset value, BuildContext context) {
    var locale = Translation.locale(context);
    switch (value) {
      case DatePreset.week:
        return '7 ${locale.days}';
      case DatePreset.month:
        return '30 ${locale.days}';
      case DatePreset.trimestre:
        return '3 ${locale.months}';
      case DatePreset.halfyear:
        return '6 ${locale.months}';
      case DatePreset.year:
        return '1 ${locale.years}';
      case DatePreset.yeartodate:
        return locale.yeartodate;

      default:
        return locale.today;
    }
  }
}
