import 'package:flutter/material.dart';
import 'package:helse/ui/common/notification.dart';

class IconOverlayController {
  Future<void> Function()? _hide;

  Future<void> hide() async {
    await _hide?.call();
  }
}

class IconOverlay extends StatefulWidget {
  final NotificationKind kind;
  final IconOverlayController controller;
  const IconOverlay(this.kind, {super.key, required this.controller});

  @override
  State<IconOverlay> createState() => _IconOverlayState();
}

class _IconOverlayState extends State<IconOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();

    widget.controller._hide = () => _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    IconData icon;
    Color color;
    switch (widget.kind) {
      case NotificationKind.error:
        color = theme.errorContainer;
        icon = Icons.dangerous_sharp;
      case NotificationKind.warning:
        color = theme.secondaryContainer;
        icon = Icons.warning_sharp;
      case NotificationKind.success:
        color = Colors.green;
        icon = Icons.check_circle_sharp;
      default:
        color = theme.surfaceContainerHighest;
        icon = Icons.info_sharp;
    }
    return FadeTransition(
      opacity: _controller,
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: 60,
              right: 20,
              child: Material(
                elevation: 20,
                color: Colors.white,
                shape: const CircleBorder(),
                child: Padding(
                  padding: EdgeInsets.all(1),
                  child: Icon(icon, color: color, size: 80),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
