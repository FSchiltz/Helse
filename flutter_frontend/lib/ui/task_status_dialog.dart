import 'package:flutter/material.dart';
import 'package:helse/helpers/date.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/logic/event.dart';
import 'package:helse/logic/fit/task_bloc.dart';

class TaskStatusDialog extends StatelessWidget {
  final List<Execution> tasks;
  final String title;
  const TaskStatusDialog(this.tasks, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    var locale = Translation.locale(context);
    return AlertDialog(
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
                          itemBuilder: (x, key) {
                            var theme = Theme.of(x).textTheme;
                            var task = tasks[key];
                            Color color = Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest;

                            if (task.state == SubmissionStatus.failure) {
                              color = Theme.of(
                                context,
                              ).colorScheme.errorContainer;
                            } else if (task.state == SubmissionStatus.success) {
                              color = Theme.of(
                                context,
                              ).colorScheme.primaryContainer;
                            } else if (task.state ==
                                SubmissionStatus.inProgress) {
                              color = Theme.of(
                                context,
                              ).colorScheme.secondaryContainer;
                            }

                            return Container(
                              padding: EdgeInsets.all(8),
                              color: color,
                              child: Column(
                                children: [
                                  Text(
                                    '${task.title ?? task.state.name} at ${DateHelper.format(task.date, context: x)}',
                                    style: theme.bodyLarge,
                                  ),
                                  Text(
                                    task.status ?? '',
                                    style: theme.bodySmall,
                                  ),

                                  if (task.progress != null &&
                                      (task.progress ?? 0) < 100)
                                    Row(
                                      children: [
                                        SizedBox(width: 12),
                                        Text(
                                          '${task.progress?.toStringAsFixed(2)}%',
                                        ),
                                        SizedBox(width: 8),
                                        Flexible(
                                          child: LinearProgressIndicator(
                                            value: (task.progress ?? 0) / 100,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(child: Text(task.state.name)),
                                      ],
                                    ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
