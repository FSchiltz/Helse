import 'package:flutter/material.dart';

class CommonCard extends StatelessWidget {
  final Widget child;
  final bool padding;
  final Color? color;
  const CommonCard({
    super.key,
    required this.child,
    this.padding = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (padding) {
      content = Padding(padding: EdgeInsetsGeometry.all(16), child: child);
    } else {
      content = child;
    }

    return Card(
      elevation: 2,
      color: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      shadowColor: Theme.of(context).colorScheme.shadow,
      child: content,
    );
  }
}
