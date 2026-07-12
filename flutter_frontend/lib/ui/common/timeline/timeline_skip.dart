import 'package:flutter/material.dart';

class TimelineSkip extends StatelessWidget {
  const TimelineSkip(this.skippedWidth, this.widthCoef, {super.key});

  final int skippedWidth;
  final double widthCoef;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return SizedBox(
      width: skippedWidth.toDouble() * widthCoef,
      child: Row(
        children: [
          Expanded(child: Divider(thickness: 1, color: theme.outlineVariant)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              Icons.fast_forward_sharp,
              size: 14,
              color: theme.primary,
            ),
          ),
          Expanded(child: Divider(thickness: 1, color: theme.outlineVariant)),
        ],
      ),
    );
  }
}
