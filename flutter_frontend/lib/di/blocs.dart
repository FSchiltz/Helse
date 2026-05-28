import 'package:helse/di/logics.dart';
import 'package:helse/logic/fit/fit_logic.dart';
import 'package:helse/logic/fit/status_bloc.dart';
import 'package:helse/logic/fit/task_bloc.dart';

class Blocs {
  TaskBloc fit;
  StatusBloc jobs;

  Blocs.build(this.fit, this.jobs);

  factory Blocs(Logics logic) {
    return Blocs.build(
      TaskBloc(
        logic.fit.sync,
        const Duration(seconds: 30),
        FitLogic.isEnabled,
      ),
      StatusBloc(
        logic.import.sync,
        const Duration(seconds: 1),
        logic.import.isEnabled,
      ),
    );
  }
}
