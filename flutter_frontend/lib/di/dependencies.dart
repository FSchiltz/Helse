import 'package:helse/di/blocs.dart';
import 'package:helse/di/logics.dart';
import 'package:helse/di/services.dart';
import 'package:helse/services/account.dart';
import 'package:health/health.dart';
import '../logic/theme_helper.dart';

class Dependencies {
  static Blocs? _blocs;
  static Blocs get blocs {
    var a = _blocs;
    if (a == null) {
      throw Exception("Invalid access");
    }
    return a;
  }

  static Services? _services;
  static Services get services {
    var a = _services;
    if (a == null) {
      throw Exception("Invalid access");
    }
    return a;
  }

  static Logics? _logics;
  static Logics get logics {
    var a = _logics;
    if (a == null) {
      throw Exception("Invalid access");
    }
    return a;
  }

  static Health health = Health();

  static ThemeHelper theme = ThemeHelper();

  static Future<void> init() async {
    var account = Account();

    await Account.setup();
    _services = Services(account);
    _logics = Logics(account, services);
    _blocs = Blocs(logics);
  }
}
