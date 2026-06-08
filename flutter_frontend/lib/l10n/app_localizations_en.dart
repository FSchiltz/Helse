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
  String get deleteMetric => 'Delete the metric ?';

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

  @override
  String get serverurl => 'Server url';

  @override
  String get url => 'url';

  @override
  String invalid(String item) {
    return 'Invalid $item';
  }

  @override
  String get login => 'Login';

  @override
  String loginwith(String provider) {
    return 'Login with $provider';
  }

  @override
  String get create => 'Create';

  @override
  String get createAccount => 'Create your account';

  @override
  String get adminDescription => 'This is the admin account for the server';

  @override
  String get welcome => 'Welcome';

  @override
  String get welcomenew => 'User created, welcome';

  @override
  String get deleteUser => 'Delete the user ?';

  @override
  String get delete => 'Delete';

  @override
  String get saved => 'Saved succefully';

  @override
  String get save => 'Save';

  @override
  String get events => 'Events';

  @override
  String get metrics => 'Metrics';

  @override
  String get metricgroups => 'Metric Groups';

  @override
  String get visible => 'Visible';

  @override
  String get widgetType => 'Widget type';

  @override
  String get detailType => 'Detail type';

  @override
  String get date => 'Date';

  @override
  String get value => 'Value';

  @override
  String get tag => 'Tag';

  @override
  String get source => 'Source';

  @override
  String get treatment => 'treatment';

  @override
  String get showOnDashboard => 'Show on dashboard';

  @override
  String get patientsSettings => 'Patient Settings';

  @override
  String get localSettings => 'Settings';

  @override
  String get general => 'General';

  @override
  String get healthsync => 'Health sync';

  @override
  String get users => 'Users';

  @override
  String get enable => 'Enable';

  @override
  String lastRun(String date) {
    return 'Last run: $date';
  }

  @override
  String get resetLastRun => 'Reset last run';

  @override
  String get syncFit => 'Sync from Google Health';

  @override
  String get syncBackgroundToggle => 'Sync in the background';

  @override
  String get syncHistoryToggle => 'Sync also historical data';

  @override
  String get sessions => 'Connection sessions';

  @override
  String get cleanSessions => 'Remove all sessions';

  @override
  String get constants => 'Constants';

  @override
  String get id => 'Id';

  @override
  String get code => 'Code';

  @override
  String get unit => 'Unit';

  @override
  String get group => 'Group';

  @override
  String get summary => 'Summary';
}
