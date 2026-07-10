import 'package:flutter/material.dart';

class TimelineLabels extends StatelessWidget {
  const TimelineLabels({
    super.key,
    required this.labels,
    required this.height,
  });

  final List<String> labels;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: labels.map((label) {
        return SizedBox(
          height: height,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 4),
              child: Text(label, overflow: TextOverflow.ellipsis, maxLines: 1),
            ),
          ),
        );
      }).toList(),
    );
  }
}
