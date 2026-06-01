import 'package:helse/di/dependencies.dart';
import 'package:workmanager/workmanager.dart';


@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "data_sync":
        await syncDataWithServer();
        break;
      default:
        // Handle unknown task types
        break;
    }

    return Future.value(true);
  });
}

Future<void> syncDataWithServer() async {
  Dependencies.init();
  if (await Dependencies.logics.fit.isEnabled()) {
    await Dependencies.logics.fit.sync();
  }
}
