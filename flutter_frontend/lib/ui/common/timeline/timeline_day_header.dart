import 'package:flutter/material.dart';

class TimelineDayHeader extends StatelessWidget {
  const TimelineDayHeader(this.width, this.date, {super.key});

  final double width;
  final DateTime date;

  @override
  Widget build(BuildContext context) => Container(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    alignment: Alignment.centerLeft,
    width: width,
    child: Text(
      ' ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().padLeft(4, '0')}',
    ),
  );
}
