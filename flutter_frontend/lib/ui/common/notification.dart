import 'package:flutter/material.dart';
import 'package:helse/main.dart';

class Notify {
  static void simple(String content) {
    final snackBar = SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 3),
      showCloseIcon: true,
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    snackbarKey.currentState?.showSnackBar(snackBar);
  }

  static void showError(String content, BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final snackBar = SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 3),
      showCloseIcon: true,
      backgroundColor: theme.errorContainer,
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void show(String content, BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final snackBar = SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 3),
      showCloseIcon: true,
      backgroundColor: theme.surfaceContainerHighest,
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
