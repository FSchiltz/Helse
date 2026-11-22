import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/logic/task_bloc.dart';
import 'package:helse/ui/task_status_dialog.dart';

class ServerJobDialog extends StatelessWidget {
  const ServerJobDialog({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>.value(
      value: Dependencies.blocs.jobs,
      child: BlocBuilder<TaskBloc, Execution>(
        builder: (context, state) {
          final jobs = Dependencies.blocs.jobs;
          return TaskStatusDialog([
            if (jobs.isReporting) state,
            ...jobs.reportedExecutions,
            ...Dependencies.logics.import.executions(),
          ], Translation.of(context).importHistory);
        },
      ),
    );
  }
}
