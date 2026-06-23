import 'package:flutter/material.dart';
import 'package:helse/main.dart';

class Notify {
  static void showError(String content) {
    final snackBar = SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 3),
      showCloseIcon: true,
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    snackbarKey.currentState?.showSnackBar(snackBar);
  }

  static void show(String content) {
    final snackBar = SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 3),
      showCloseIcon: true,
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    snackbarKey.currentState?.showSnackBar(snackBar);
  }
}
