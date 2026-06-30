import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/main.dart';

enum NotificationKind { info, warning, error }

class Notify {
  static const notificationSettings = "notificationAsked";
  static bool enabled = false;
  static FlutterLocalNotificationsPlugin? _localNotifications;


  static Future<void> init() async {
    if (kIsWeb) {
      // disabled on webs
      enabled = false;
      return;
    }

    _localNotifications = FlutterLocalNotificationsPlugin();
    final initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("ic_launcher"),
      linux: LinuxInitializationSettings(defaultActionName: "open"),
    );
    enabled =
        await _localNotifications?.initialize(
          settings: initializationSettings,
        ) ??
        false;

    await _askPermission();
  }

  static Future<void> show(
    String content, {
    String? description,
    BuildContext? context,
    NotificationKind kind = NotificationKind.info,
    bool isBackground = false,
  }) async {
    if (enabled && isBackground) {
      _showSystem(content, description, kind);
    } else {
      // if the user has not enabled notification, fallback to in app toast
      _show(content, kind, context);
    }
  }

  static void _show(
    String content,
    NotificationKind kind,
    BuildContext? context,
  ) {
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

  static Future<void> _askPermission() async {
    // ask for permission on android
    final android = _localNotifications
        ?.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (android == null) return;

    var isEnabled = await android.areNotificationsEnabled();
    if (enabled != true) {
      var alreadyAsked = Dependencies.logics.settings.getBool(
        notificationSettings,
      );

      if (alreadyAsked != true) {
        isEnabled = await android.requestNotificationsPermission();

        await Dependencies.logics.settings.setBool(notificationSettings, true);
      }
    }
    enabled = isEnabled == true;
  }

  static Future<void> _showSystem(
    String content,
    String? description,
    NotificationKind kind,
  ) async {
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

    await _localNotifications?.show(
      id: 0,
      title: content,
      body: description,
      notificationDetails: notificationDetails,
      payload: 'item x',
    );
  }
}
