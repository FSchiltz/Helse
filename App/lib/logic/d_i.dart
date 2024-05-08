import 'package:helse/helpers/oauth.dart';
import 'package:helse/logic/account/authentication_logic.dart';
import 'package:helse/logic/fit/task_bloc.dart';
import 'package:helse/logic/settings/settings_logic.dart';
import 'package:helse/services/account.dart';
import 'package:helse/services/event_service.dart';
import 'package:helse/services/helper_service.dart';
import 'package:helse/services/metric_service.dart';
import 'package:helse/services/treatment_service.dart';
import 'package:helse/services/user_service.dart';

import 'fit/fit_logic.dart';

class DI {
  static OauthClient? authService;
  static AuthenticationLogic? _authentication;

  static AuthenticationLogic get authentication {
    var a = _authentication;
    if (a == null) {
      throw Exception("Invalid access");
    }
    return a;
  }

  static MetricService? metric;
  static HelperService? helper;
  static EventService? event;
  static UserService? user;
  static TreatmentService? treatement;
  static SettingsLogic? settings;

  static TaskBloc? _fit;
  static TaskBloc get fit {
    var a = _fit;
    if (a == null) {
      throw Exception("Invalid access");
    }
    return a;
  }

  static void init() {
    var account = Account();
    authService = OauthClient(account);
    _authentication = AuthenticationLogic(account);
    metric = MetricService(account);
    helper = HelperService(account);
    event = EventService(account);
    user = UserService(account);
    treatement = TreatmentService(account);
    settings = SettingsLogic(account);

    var fitLogic = FitLogic(account);
    _fit = TaskBloc(fitLogic.sync, const Duration(seconds: 30)); // TODO use a background task
  }
}
