import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:helse/di/dependencies.dart';
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
    if (kIsWeb) {
      // disabled on webs
      enabled = false;
      return;
    }

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("ic_launcher"),
      linux: LinuxInitializationSettings(defaultActionName: "open"),
    );
    enabled =
        await _flutterLocalNotificationsPlugin?.initialize(
          settings: initializationSettings,
        ) ??
        false;

    // ask for permission on android
    final android = _flutterLocalNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      var isEnabled = await android.areNotificationsEnabled();
      if (enabled != true) {
        var alreadyAsked = Dependencies.logics.settings.getBool(
          "notificationAsked",
        );
        if (alreadyAsked != true) {
          isEnabled = await android.requestNotificationsPermission();

          await Dependencies.logics.settings.setBool("notificationAsked", true);
        }
      }
      enabled = isEnabled == true;
    }
  }

  static Future<void> showBackground(
    String content, {
    String? description,
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
        linux: LinuxNotificationDetails(
          urgency: LinuxNotificationUrgency.critical,
          category: LinuxNotificationCategory.emailArrived,
          resident: true,
          timeout: LinuxNotificationTimeout.systemDefault(),
        ),
        web: WebNotificationDetails(),
      );

      await _flutterLocalNotificationsPlugin?.show(
        id: 0,
        title: content,
        body: description,
        notificationDetails: notificationDetails,
        payload: 'item x',
      );
    } else {
      // if the user has not enabled notification, fallback to in app toast
      show(content, kind: kind);
    }
  }
}
