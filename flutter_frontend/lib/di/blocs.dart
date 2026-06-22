import 'dart:developer';

import 'package:helse/di/logics.dart';
import 'package:helse/logic/fit/fit_helper.dart';
import 'package:helse/logic/fit/status_bloc.dart';
import 'package:helse/logic/fit/task_bloc.dart';

class Blocs {
  TaskBloc fit;
  StatusBloc jobs;

  Blocs.build(this.fit, this.jobs);

  factory Blocs(Logics logic) {
    return Blocs.build(
      TaskBloc(
        () async {
          log("Started sync");
          final enabled = logic.fit.isEnabled();
          if (enabled) {
            await logic.fit.checkRun();
            return await logic.fit.sync();
          } else {
            log("Skipped fit sync");
            return null;
          }
        },
        const Duration(minutes: 5),
        FitHelper.isSupported,
      ),
      StatusBloc(
        logic.import.sync,
        const Duration(seconds: 3),
        logic.import.isEnabled,
      ),
    );
  }
}
