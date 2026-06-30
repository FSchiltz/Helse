import 'package:flutter/material.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/logic/event.dart';
import 'package:helse/logic/task_bloc.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';
import 'package:helse/ui/common/ui_constants.dart';

class TaskStatusDialog extends StatelessWidget {
  final List<Execution> tasks;
  final String title;
  const TaskStatusDialog(this.tasks, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return SquareDialog(
      title: Text(title),
      content: tasks.isEmpty
          ? Text(locale.notask)
          : Scrollbar(
              interactive: true,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 400,
                  height: 800,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (x, key) => _taskCard(tasks[key], x),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Container _taskCard(Execution task, BuildContext context) {
    var theme = Theme.of(context).textTheme;
    Color color = Theme.of(context).colorScheme.surfaceContainerHighest;
    if (task.state == SubmissionStatus.failure) {
      color = Theme.of(context).colorScheme.errorContainer;
    } else if (task.state == SubmissionStatus.success) {
      color = Theme.of(context).colorScheme.primaryContainer;
    } else if (task.state == SubmissionStatus.inProgress) {
      color = Theme.of(context).colorScheme.secondaryContainer;
    }

    final hasProgress = task.progress != null && (task.progress ?? 0) < 100;

    return Container(
      margin: const EdgeInsets.all(UIConstants.tablePad),
      padding: const EdgeInsets.all(UIConstants.formPad),
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${task.title ?? task.state.name} at ${DateHelper.format(task.date, context: context)}',
            style: theme.bodyMedium,
          ),
          Text(task.status ?? '', style: theme.bodySmall),

          Row(
            spacing: UIConstants.formPad,
            children: [
              Flexible(child: Text(task.state.name)),
              if (hasProgress)
                Flexible(
                  child: Stack(
                    children: [
                      LinearProgressIndicator(
                        value: (task.progress ?? 0) / 100,
                        minHeight: 20,
                      ),
                      Center(
                        child: Text('${task.progress?.toStringAsFixed(2)}%'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
