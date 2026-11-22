import 'package:helse/services/account.dart';
import 'package:helse/services/admin_service.dart';
import 'package:helse/services/api/api_admin_service.dart';
import 'package:helse/services/api/api_common_service.dart';
import 'package:helse/services/api/api_event_service.dart';
import 'package:helse/services/api/api_file_service.dart';
import 'package:helse/services/api/api_import_service.dart';
import 'package:helse/services/api/api_login_service.dart';
import 'package:helse/services/api/api_metric_service.dart';
import 'package:helse/services/api/api_setting_service.dart';
import 'package:helse/services/common_service.dart';
import 'package:helse/services/event_service.dart';
import 'package:helse/services/file_service.dart';
import 'package:helse/services/import_service.dart';
import 'package:helse/services/local/local_admin_service.dart';
import 'package:helse/services/local/local_common_service.dart';
import 'package:helse/services/local/local_event_service.dart';
import 'package:helse/services/local/local_file_service.dart';
import 'package:helse/services/local/local_import_service.dart';
import 'package:helse/services/local/local_login_service.dart';
import 'package:helse/services/local/local_metric_service.dart';
import 'package:helse/services/local/local_setting_service.dart';
import 'package:helse/services/local/local_user_service.dart';
import 'package:helse/services/login_service.dart';
import 'package:helse/services/metric_service.dart';
import 'package:helse/services/settings_services.dart';
import 'package:helse/services/api/api_user_service.dart';
import 'package:helse/services/user_service.dart';

class Services {
  MetricService metric;
  EventService event;
  ImportService import;
  UserService user;
  AdminService admin;
  SettingService settings;
  CommonService common;
  FileService files;
  LoginService login;

  Services.build(
    this.metric,
    this.event,
    this.user,
    this.admin,
    this.import,
    this.settings,
    this.common,
    this.files,
    this.login,
  );

  factory Services.online(Account account) {
    return Services.build(
      ApiMetricService(account),
      ApiEventService(account),
      ApiUserService(account),
      ApiAdminService(account),
      ApiImportService(account),
      ApiSettingService(account),
      ApiCommonService(account),
      ApiFileService(account),
      ApiLoginService(account),
    );
  }

  factory Services.offline(Account account) {
    return Services.build(
      LocalMetricService(account),
      LocalEventService(account),
      LocalUserService(account),
      LocalAdminService(account),
      LocalImportService(account),
      LocalSettingService(account),
      LocalCommonService(account),
      LocalFileService(account),
      LocalLoginService(account),
    );
  }
}
