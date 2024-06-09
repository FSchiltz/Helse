import 'package:health/health.dart';
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
  static MetricService? _metric;
  static MetricService get metric {
    var a = _metric;
    if (a == null) {
      throw Exception("Invalid access");
    }
    return a;
  }

  static HelperService? _helper;
  static HelperService get helper {
    var a = _helper;
    if (a == null) {
      throw Exception("Invalid access");
    }
    return a;
  }

  static EventService? _event;
  static EventService get event {
    var a = _event;
    if (a == null) {
      throw Exception("Invalid access");
    }
    return a;
  }

  static UserService? _user;
    static UserService get user {
    var a = _user;
    if (a == null) {
      throw Exception("Invalid access");
    }
    return a;
  }
  static TreatmentService? treatement;
  static SettingsLogic? _settings;
  static SettingsLogic get settings {
    var a = _settings;
    if (a == null) {
      throw Exception("Invalid access");
    }
    return a;
  }

  static Health? _health;
  static Health get health {
    var a = _health;
    if (a == null) {
      throw Exception("Invalid access");
    }
    return a;
  }

  static AuthenticationLogic? _authentication;
  static AuthenticationLogic get authentication {
    var a = _authentication;
    if (a == null) {
      throw Exception("Invalid access");
    }
    return a;
  }

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
    _metric = MetricService(account);
    _helper = HelperService(account);
    _event = EventService(account);
    _user = UserService(account);
    treatement = TreatmentService(account);
    _settings = SettingsLogic(account);
    _health = Health();

    var fitLogic = FitLogic(account);
    _fit = TaskBloc(fitLogic.sync, const Duration(seconds: 30), FitLogic.isEnabled);
  }
}
