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

  static Services? _online;
  static Services? _offline;
  static Services get services {
    var a = blocs.server.isOffline ? _offline : _online;
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

  static Future<void> init({Account? account}) async {
    if (account == null) {
      account = Account();

      await account.setup();
    }

    _online = Services.online(account);
    _offline = Services.offline(account);
    _logics = Logics(account);
    _blocs = Blocs(logics);
  }
}
