import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class Notify {
  static void showError(String content) {
    toastification.show(
      title: Text(content),
      type: ToastificationType.error,
      style: ToastificationStyle.minimal,
      autoCloseDuration: const Duration(seconds: 5)
    );
  }

  static void show(String content) {
    toastification.show(
      title: Text(content),
      type: ToastificationType.success,
      style: ToastificationStyle.minimal,
      autoCloseDuration: const Duration(seconds: 5)
    );
  }
}
