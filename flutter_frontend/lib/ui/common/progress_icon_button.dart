import 'package:flutter/material.dart';
import 'package:helse/logic/event.dart';
import 'package:helse/logic/task_bloc.dart';
import 'package:helse/ui/common/loader.dart';

class ProgressIconButton extends StatelessWidget {
  const ProgressIconButton({
    super.key,
    required this.state,
    this.icon,
    required this.onOpen,
  });

  final Execution state;
  final IconData? icon;
  final void Function() onOpen;

  @override
  Widget build(BuildContext context) {
    Color? color;
    bool static = true;
    switch (state.state) {
      case SubmissionStatus.success:
        color = Colors.green;
        break;
      case SubmissionStatus.failure:
        color = Colors.red;
        break;
      case SubmissionStatus.inProgress:
        static = false;
        break;
      default:
        color = null;
    }

    return Stack(
      children: [
        if (state.progress != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              width: 40,
              height: 6,
              child: LinearProgressIndicator(
                value: (state.progress ?? 0) / 100,
              ),
            ),
          ),
        HelseLoader(
          static: static,
          color: color,
          size: 22,
          onTouch: onOpen,
          icon: icon,
        ),
      ],
    );
  }
}
