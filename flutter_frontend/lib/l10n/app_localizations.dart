import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @administration.
  ///
  /// In en, this message translates to:
  /// **'Administration'**
  String get administration;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get months;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @yeartodate.
  ///
  /// In en, this message translates to:
  /// **'Year to date'**
  String get yeartodate;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @importHistory.
  ///
  /// In en, this message translates to:
  /// **'File import history'**
  String get importHistory;

  /// No description provided for @syncHistory.
  ///
  /// In en, this message translates to:
  /// **'Health sync history'**
  String get syncHistory;

  /// No description provided for @initialrange.
  ///
  /// In en, this message translates to:
  /// **'Initial range'**
  String get initialrange;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'start'**
  String get start;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'stop'**
  String get stop;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'end'**
  String get end;

  /// No description provided for @notificationTime.
  ///
  /// In en, this message translates to:
  /// **'notification time'**
  String get notificationTime;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error(String error);

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surname;

  /// No description provided for @confirmpassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmpassword;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @eventSettings.
  ///
  /// In en, this message translates to:
  /// **'Events Settings'**
  String get eventSettings;

  /// No description provided for @generalSettings.
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get generalSettings;

  /// No description provided for @metricSettings.
  ///
  /// In en, this message translates to:
  /// **'Metrics Settings'**
  String get metricSettings;

  /// No description provided for @userSettings.
  ///
  /// In en, this message translates to:
  /// **'Users Settings'**
  String get userSettings;

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'Added succesfully'**
  String get added;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add a new {item}'**
  String addItem(String item);

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @addPatients.
  ///
  /// In en, this message translates to:
  /// **'Add a new patient'**
  String get addPatients;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @patients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patients;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteMetric.
  ///
  /// In en, this message translates to:
  /// **'Delete the metric ?'**
  String get deleteMetric;

  /// No description provided for @deleteEvent.
  ///
  /// In en, this message translates to:
  /// **'Delete the event ?'**
  String get deleteEvent;

  /// No description provided for @detailof.
  ///
  /// In en, this message translates to:
  /// **'Detail of {item}'**
  String detailof(String item);

  /// No description provided for @range.
  ///
  /// In en, this message translates to:
  /// **'from {from} to {to}'**
  String range(String from, String to);

  /// No description provided for @nodata.
  ///
  /// In en, this message translates to:
  /// **'no data'**
  String get nodata;

  /// No description provided for @notask.
  ///
  /// In en, this message translates to:
  /// **'no tasks'**
  String get notask;

  /// No description provided for @serverurl.
  ///
  /// In en, this message translates to:
  /// **'Server url'**
  String get serverurl;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'url'**
  String get url;

  /// No description provided for @invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid {item}'**
  String invalid(String item);

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginwith.
  ///
  /// In en, this message translates to:
  /// **'Login with {provider}'**
  String loginwith(String provider);

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createAccount;

  /// No description provided for @adminDescription.
  ///
  /// In en, this message translates to:
  /// **'This is the admin account for the server'**
  String get adminDescription;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomenew.
  ///
  /// In en, this message translates to:
  /// **'User created, welcome'**
  String get welcomenew;

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete the user ?'**
  String get deleteUser;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved succefully'**
  String get saved;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @metrics.
  ///
  /// In en, this message translates to:
  /// **'Metrics'**
  String get metrics;

  /// No description provided for @metricgroups.
  ///
  /// In en, this message translates to:
  /// **'Metric Groups'**
  String get metricgroups;

  /// No description provided for @visible.
  ///
  /// In en, this message translates to:
  /// **'Visible'**
  String get visible;

  /// No description provided for @widgetType.
  ///
  /// In en, this message translates to:
  /// **'Widget type'**
  String get widgetType;

  /// No description provided for @detailType.
  ///
  /// In en, this message translates to:
  /// **'Detail type'**
  String get detailType;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @tag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get tag;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @treatment.
  ///
  /// In en, this message translates to:
  /// **'treatment'**
  String get treatment;

  /// No description provided for @showOnDashboard.
  ///
  /// In en, this message translates to:
  /// **'Show on dashboard'**
  String get showOnDashboard;

  /// No description provided for @patientsSettings.
  ///
  /// In en, this message translates to:
  /// **'Patient Settings'**
  String get patientsSettings;

  /// No description provided for @localSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get localSettings;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @healthsync.
  ///
  /// In en, this message translates to:
  /// **'Health sync'**
  String get healthsync;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @lastRun.
  ///
  /// In en, this message translates to:
  /// **'Last run: {date}'**
  String lastRun(String date);

  /// No description provided for @resetLastRun.
  ///
  /// In en, this message translates to:
  /// **'Reset last run'**
  String get resetLastRun;

  /// No description provided for @syncFit.
  ///
  /// In en, this message translates to:
  /// **'Sync from Google Health'**
  String get syncFit;

  /// No description provided for @syncBackgroundToggle.
  ///
  /// In en, this message translates to:
  /// **'Sync in the background'**
  String get syncBackgroundToggle;

  /// No description provided for @syncHistoryToggle.
  ///
  /// In en, this message translates to:
  /// **'Sync also historical data'**
  String get syncHistoryToggle;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get sessions;

  /// No description provided for @cleanSessions.
  ///
  /// In en, this message translates to:
  /// **'Remove all sessions'**
  String get cleanSessions;

  /// No description provided for @constants.
  ///
  /// In en, this message translates to:
  /// **'Constants'**
  String get constants;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'Id'**
  String get id;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @mean.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get mean;

  /// No description provided for @eventInformationSummary.
  ///
  /// In en, this message translates to:
  /// **'Total of {total} in {length} sessions with an average of {mean}'**
  String eventInformationSummary(String total, String length, String mean);

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @searchItem.
  ///
  /// In en, this message translates to:
  /// **'Search a {item}'**
  String searchItem(String item);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
