import 'package:flutter/material.dart';
import 'package:helse/ui/common/notification.dart';

class IconOverlay extends StatelessWidget {
  final NotificationKind kind;
  const IconOverlay(this.kind, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    IconData icon;
    Color color;
    switch (kind) {
      case NotificationKind.error:
        color = theme.errorContainer;
        icon = Icons.dangerous_sharp;
      case NotificationKind.warning:
        color = theme.secondaryContainer;
        icon = Icons.warning_sharp;
      default:
        color = theme.surfaceContainerHighest;
        icon = Icons.check_circle_sharp;
    }

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            bottom: 40,
            right: 20,
            child: Material(
              elevation: 2,
              color: color,
              shape: const CircleBorder(),
              child: Padding(
                padding: EdgeInsets.all(18),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.2, end: 1.0),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.scale(scale: value, child: child),
                    );
                  },
                  child: Icon(icon, color: Colors.white, size: 60),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
