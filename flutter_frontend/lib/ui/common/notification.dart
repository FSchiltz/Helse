import 'package:flutter/material.dart';
import 'package:helse/main.dart';

enum NotificationKind { info, warning, error }

class Notify {
  static void simple(String content, NotificationKind kind) {
    final snackBar = SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 3),
      showCloseIcon: true,
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    snackbarKey.currentState?.showSnackBar(snackBar);
  }

  static void show(
    String content,
    BuildContext context,
    NotificationKind kind,
  ) {
    final theme = Theme.of(context).colorScheme;
    var color = theme.surfaceContainerHighest;

    if (kind == NotificationKind.error) {
      color = theme.errorContainer;
    } else if (kind == NotificationKind.warning) {
      color = theme.secondaryContainer;
    }

    final snackBar = SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 3),
      showCloseIcon: true,
      backgroundColor: color,
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
