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
    EdgeInsets? margin;
    if (padding) {
      content = Padding(padding: EdgeInsetsGeometry.all(16), child: child);
      margin = null;
    } else {
      content = child;
      margin = EdgeInsets.all(0);
    }

    return Card(
      margin: margin,
      elevation: 2,
      color: color ?? Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      shadowColor: Theme.of(context).colorScheme.shadow,
      child: content,
    );
  }
}
