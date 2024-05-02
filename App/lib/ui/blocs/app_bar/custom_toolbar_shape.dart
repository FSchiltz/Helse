import 'package:flutter/material.dart';

class CustomToolbarShape extends CustomPainter {
  final ColorScheme theme;

  const CustomToolbarShape({required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    //First oval
    Path path = Path();
    Rect pathGradientRect = Rect.fromCircle(
      center: Offset(size.width / 4, 0),
      radius: size.width / 1.8,
    );

    Gradient gradient = LinearGradient(
      colors: <Color>[
        theme.primaryContainer.withOpacity(0.6),
        theme.primaryContainer,
      ],
      stops: const [
        0.5,
        1.0,
      ],
    );

    path.lineTo(-size.width / 1.4, 0);
    path.quadraticBezierTo(size.width / 6, size.height * 2.5, size.width + size.width / 1.5, 0);

    paint.color = theme.primaryContainer;
    paint.shader = gradient.createShader(pathGradientRect);
    paint.strokeWidth = 40;
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
