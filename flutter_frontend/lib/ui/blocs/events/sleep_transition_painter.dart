import 'dart:math';
import 'package:flutter/material.dart';
import 'package:helse/ui/blocs/events/events_timeline_graph.dart';

class SleepTransitionPainter extends CustomPainter {
  final List<EventLayout> layouts;

  SleepTransitionPainter(this.layouts);

  @override
  void paint(Canvas canvas, Size size) {
    if (layouts.length < 2) return;

    final sorted = [...layouts]
      ..sort((a, b) => a.event.start.compareTo(b.event.start));

    for (int i = 0; i < sorted.length - 1; i++) {
      final current = sorted[i];
      final next = sorted[i + 1];

      final gap = next.event.start
          .difference(current.event.stop)
          .inMinutes
          .abs();

      if (gap > 15) continue;

      final connectorX = current.right;
      List<Color> colors;
      if (current.centerY > next.centerY) {
        colors = [next.color.withAlpha(150), current.color.withAlpha(150)];
      } else {
        colors = [current.color.withAlpha(150), next.color.withAlpha(150)];
      }
      final paint = Paint()
        ..shader =
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors,
              stops: const [0.0, 1.0],
            ).createShader(
              Rect.fromLTRB(
                connectorX - 1,
                min(current.centerY, next.centerY),
                connectorX + 1,
                max(current.centerY, next.centerY),
              ),
            )
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final path = Path()
        ..moveTo(connectorX - 1, current.centerY)
        ..lineTo(next.left + 1, next.centerY);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SleepTransitionPainter oldDelegate) => true;
}
