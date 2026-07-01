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
          : SizedBox(
              height: 800,
              width: 400,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: tasks.length,
                itemBuilder: (x, key) => _taskCard(tasks[key], x),
              ),
            ),
    );
  }

  Container _taskCard(Execution task, BuildContext context) {
    var theme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    Color color = Theme.of(context).colorScheme.surfaceContainerHighest;
    IconData icon;
    switch (task.state) {
      case SubmissionStatus.failure:
        color = colorScheme.errorContainer;
        icon = Icons.dangerous_sharp;
      case SubmissionStatus.success:
        color = colorScheme.primaryContainer;
        icon = Icons.check_circle_sharp;
      case SubmissionStatus.inProgress:
        color = colorScheme.secondaryContainer;
        icon = Icons.hourglass_bottom_sharp;
      case SubmissionStatus.initial:
        color = colorScheme.surfaceContainerLowest;
        icon = Icons.hourglass_top_sharp;
      case SubmissionStatus.waiting:
      case SubmissionStatus.skipped:
        icon = Icons.hourglass_disabled_sharp;
    }

    final hasProgress = task.progress != null && (task.progress ?? 0) < 100;

    return Container(
      margin: const EdgeInsets.all(UIConstants.tablePad),
      padding: const EdgeInsets.all(UIConstants.formPad),
      color: color,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: UIConstants.tablePad,
        children: [
          Icon(icon),
          Text(task.title ?? task.state.name, style: theme.bodyMedium),
          Text(
            'at ${DateHelper.format(task.date, context: context)}',
            style: theme.bodyMedium,
          ),
          Text(task.status ?? '', style: theme.bodySmall),
          if (hasProgress)
            Stack(
              children: [
                LinearProgressIndicator(
                  value: (task.progress ?? 0) / 100,
                  minHeight: 20,
                ),
                Center(child: Text('${task.progress?.toStringAsFixed(2)}%')),
              ],
            ),
        ],
      ),
    );
  }
}
