import 'package:flutter/material.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/translation.dart';

class DurationWidget extends StatelessWidget {
  const DurationWidget({
    super.key,
    required this.color,
    required this.duration,
  });

  final Color color;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);
    final theme = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.update, color: color),
        SizedBox(width: 4),
        Text(
          DateHelper.formatDuration(duration, locale),
          style: theme.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
