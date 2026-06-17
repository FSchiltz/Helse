import 'package:flutter/material.dart';

class SquareDialog extends StatelessWidget {
  const SquareDialog({
    super.key,
    required this.content,
    this.actions,
    this.title,
  });

  final Widget? content;
  final Text? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0.0))),
      scrollable: true,
      content: content,
      title: title,
      actions: actions,
    );
  }
}
