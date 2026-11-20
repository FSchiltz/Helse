import 'package:material_ui/material_ui.dart';

class TimelineGrid extends StatelessWidget {
  const TimelineGrid({
    super.key,
    required this.boxWidth,
  });

  final double boxWidth;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      border: Border(
        right: BorderSide(color: Colors.white.withAlpha(75), width: 0.5),
      ),
    ),
    width: boxWidth,
  );
}
