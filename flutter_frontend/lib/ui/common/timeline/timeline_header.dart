import 'package:flutter/material.dart';

class TimelineHeader extends StatelessWidget {
  const TimelineHeader({
    super.key,
    required this.boxWidth,
    required this.utc,
  });

  final double boxWidth;
  final DateTime utc;

  @override
  Widget build(BuildContext context) {
    var tempDate = utc.toLocal();
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      alignment: Alignment.centerLeft,
      width: boxWidth,
      child: Tooltip(
        message: '$tempDate',
        child: Text(
          '${tempDate.hour.toString().padLeft(2, '0')}:${tempDate.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }
}
