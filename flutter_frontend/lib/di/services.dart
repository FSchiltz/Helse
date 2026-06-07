import 'package:helse/services/account.dart';
import 'package:helse/services/admin_service.dart';
import 'package:helse/services/common_service.dart';
import 'package:helse/services/event_service.dart';
import 'package:helse/services/helper_service.dart';
import 'package:helse/services/import_service.dart';
import 'package:helse/services/metric_service.dart';
import 'package:helse/services/oauth_service.dart';
import 'package:helse/services/setting_service.dart';
import 'package:helse/services/treatment_service.dart';
import 'package:helse/services/user_service.dart';

class Services {
  OauthService authService;
  MetricService metric;
  HelperService helper;
  EventService event;
  ImportService import;
  UserService user;
  AdminService admin;
  TreatmentService treatement;
  SettingService settings;
  CommonService common;

  Services.build(
    this.authService,
    this.metric,
    this.helper,
    this.event,
    this.user,
    this.admin,
    this.treatement,
    this.import,
    this.settings,
    this.common,
  );

  factory Services(Account account) {
    return Services.build(
      OauthService(account),
      MetricService(account),
      HelperService(account),
      EventService(account),
      UserService(account),
      AdminService(account),
      TreatmentService(account),
      ImportService(account),
      SettingService(account),
      CommonService(account),
    );
  }
}
