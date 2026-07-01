import 'dart:developer';

import 'package:helse/di/logics.dart';
import 'package:helse/logic/fit/fit_helper.dart';
import 'package:helse/logic/task_bloc.dart';

class Blocs {
  TaskBloc fit;
  TaskBloc jobs;

  Blocs.build(this.fit, this.jobs);

  factory Blocs(Logics logic) {
    return Blocs.build(
      TaskBloc(
        () async {
          log("Started sync");
          final enabled = logic.health.isEnabled();
          if (enabled) {
            return await logic.health.sync();
          } else {
            log("Skipped fit sync");
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
    );
  }
}
