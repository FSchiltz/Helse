import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:helse/main.dart';

enum NotificationKind { info, warning, error }

class Notify {
  static bool enabled = false;
  static FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  static void show(
    String content, {
    BuildContext? context,
    NotificationKind kind = NotificationKind.info,
  }) {
    Color? color;
    if (context != null) {
      final theme = Theme.of(context).colorScheme;
      color = theme.surfaceContainerHighest;

      if (kind == NotificationKind.error) {
        color = theme.errorContainer;
      } else if (kind == NotificationKind.warning) {
        color = theme.secondaryContainer;
      }
    }

    final snackBar = SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 3),
      showCloseIcon: true,
      backgroundColor: color,
    );

    if (context == null) {
      snackbarKey.currentState?.showSnackBar(snackBar);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  static Future<void> init() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("app_icon"),
      linux: LinuxInitializationSettings(defaultActionName: "open"),
    );
    enabled =
        await _flutterLocalNotificationsPlugin?.initialize(
          settings: initializationSettings,
        ) ??
        false;
  }

  static Future<void> showBackground(
    String content, {
    NotificationKind kind = NotificationKind.info,
  }) async {
    if (enabled) {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
            'helse',
            'helse',
            channelDescription: 'your channel description',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            ticker: 'ticker',
          );
      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        linux: LinuxNotificationDetails(),
        web: WebNotificationDetails(),
      );

      await _flutterLocalNotificationsPlugin?.show(
        id: 0,
        title: content,
        body: 'plain body',
        notificationDetails: notificationDetails,
        payload: 'item x',
      );
    } else {
      // if the user has not enabled notification, fallback to in app toast
      show(content, kind: kind);
    }
  }
}
