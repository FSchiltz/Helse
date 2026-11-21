import 'package:helse/di/logics.dart';
import 'package:helse/di/app_logger.dart';
import 'package:helse/logic/account/authentication_bloc.dart';
import 'package:helse/logic/account/server_state.dart';
import 'package:helse/logic/fit/fit_helper.dart';
import 'package:helse/logic/task_bloc.dart';

class Blocs {
  TaskBloc fit;
  TaskBloc jobs;
  AuthenticationBloc auth;
  ServerState server;

  Blocs.build(this.fit, this.jobs, this.auth, this.server);

  factory Blocs(Logics logic) {
    return Blocs.build(
      TaskBloc(
        () async {
          appLogger.d("Started sync");
          final enabled = logic.health.isEnabled();
          if (enabled) {
            return await logic.health.sync();
          } else {
            appLogger.d("Skipped fit sync");
            return Execution.empty();
          }
        },
        const Duration(minutes: 5),
        FitHelper.isSupported,
      ),
      TaskBloc(
        logic.import.sync,
        const Duration(seconds: 3),
        logic.import.isEnabled,
      ),
      AuthenticationBloc(),
      ServerState(),
    );
  }
}
