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
    var theme = Theme.of(context).colorScheme;
    return AlertDialog(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
        side: BorderSide(color: theme.outlineVariant, width: 1),
      ),
      scrollable: true,
      content: content,
      title: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: theme.outlineVariant, width: 2),
          ),
        ),
        child: title,
      ),
      actions: actions,
      backgroundColor: theme.surfaceContainerLow,
    );
  }
}
