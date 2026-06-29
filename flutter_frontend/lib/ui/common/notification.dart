import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:helse/main.dart';

enum NotificationKind { info, warning, error }

class Notify {
  static FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

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

  static Future<void> init() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("app_icon"),
      linux: LinuxInitializationSettings(defaultActionName: "open"),
    );
    await _flutterLocalNotificationsPlugin?.initialize(
      settings: initializationSettings,
    );
  }

  static Future<void> showBackground(
    String content,
    NotificationKind kind,
  ) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      linux: LinuxNotificationDetails(),
      web: WebNotificationDetails(),
    );
    
    await _flutterLocalNotificationsPlugin?.show(
      id: 0,
      title: 'plain title',
      body: 'plain body',
      notificationDetails: notificationDetails,
      payload: 'item x',
    );
  }
}
