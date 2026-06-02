// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get administration => 'Administration';

  @override
  String get logout => 'Logout';

  @override
  String get settings => 'Settings';

  @override
  String get import => 'Import';

  @override
  String get days => 'days';

  @override
  String get months => 'months';

  @override
  String get years => 'years';

  @override
  String get yeartodate => 'Year to date';

  @override
  String get today => 'Today';

  @override
  String get importHistory => 'File import history';

  @override
  String get syncHistory => 'Health sync history';

  @override
  String get initialrange => 'Initial range';

  @override
  String get start => 'start';

  @override
  String get stop => 'stop';

  @override
  String get end => 'end';

  @override
  String get notificationTime => 'notification time';

  @override
  String error(String error) {
    return 'Error: $error';
  }

  @override
  String get password => 'Password';

  @override
  String get username => 'Username';

  @override
  String get name => 'Name';

  @override
  String get surname => 'Surname';

  @override
  String get confirmpassword => 'Confirm Password';

  @override
  String get email => 'Email';

  @override
  String get type => 'Type';

  @override
  String get eventSettings => 'Events Settings';

  @override
  String get generalSettings => 'General Settings';

  @override
  String get metricSettings => 'Metrics Settings';

  @override
  String get userSettings => 'Users Settings';

  @override
  String get added => 'Added succesfully';

  @override
  String get add => 'Add';

  @override
  String addItem(String item) {
    return 'Add a new $item';
  }

  @override
  String get submit => 'Submit';

  @override
  String get description => 'Description';

  @override
  String get addPatients => 'Add a new patient';

  @override
  String get edit => 'Edit';

  @override
  String get share => 'Share';

  @override
  String get patients => 'Patients';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteEvent => 'Delete the event ?';

  @override
  String detailof(String item) {
    return 'Detail of $item';
  }

  @override
  String range(String from, String to) {
    return 'from $from to $to';
  }

  @override
  String get nodata => 'no data';

  @override
  String get notask => 'no tasks';
}
