import 'package:flutter/material.dart';
import 'package:helse/helpers/date.dart';
import 'package:helse/logic/fit/task_bloc.dart';

class TaskStatusDialog extends StatelessWidget {
  final List<Execution> tasks;
  const TaskStatusDialog(
    this.tasks, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Health sync history'),
        content: tasks.isEmpty
            ? const Text('No tasks')
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
                              return Column(
                                children: [
                                  Text('${task.state.name} at ${DateHelper.format(task.date, context: x)}', style: theme.bodyLarge),
                                  Text(task.status ?? '', style: theme.bodySmall),
                                  const SizedBox(height: 10),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
