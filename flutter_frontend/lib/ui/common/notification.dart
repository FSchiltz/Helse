import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/main.dart';
import 'package:helse/ui/common/overlay.dart';

enum NotificationKind { info, warning, error, success }

class Notify {
  static const notificationSettings = "notificationAsked";
  static bool enabled = false;
  static OverlayEntry? _entry;
  static Timer? _timer;
  static FlutterLocalNotificationsPlugin? _localNotifications;

  static Future<void> init() async {
    if (kIsWeb) {
      // disabled on web
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

  static void showIcon(NotificationKind kind) {
    final overlay = navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    _timer?.cancel();
    _entry?.remove();

    final controller = IconOverlayController();

    final entry = OverlayEntry(
      builder: (_) => IconOverlay(kind, controller: controller),
    );

    _entry = entry;
    overlay.insert(entry);

    _timer = Timer(const Duration(seconds: 3), () async {
      await controller.hide();

      if (_entry == entry) {
        entry.remove();
        _entry = null;
      }
    });
  }

  static void showSystem(
    String content, {
    String? description,
    NotificationKind kind = NotificationKind.info,
    String? channel,
  }) {
    if (enabled) {
      _showSystem(content, description, kind, channel);
    } else {
      // if the user has not enabled notification, fallback to in app toast
      show(content, kind: kind);
    }
  }

  static void show(
    String content, {
    NotificationKind kind = NotificationKind.info,
    BuildContext? context,
  }) {
    TextStyle? style;
    Color? color;
    if (context != null) {
      final theme = Theme.of(context).colorScheme;
      final textTheme = Theme.of(context).textTheme;

      style = textTheme.headlineSmall;
      switch (kind) {
        case NotificationKind.error:
          color = theme.errorContainer;
          style = style?.copyWith(color: theme.onErrorContainer);
        case NotificationKind.warning:
          color = theme.secondaryContainer;
          style = style?.copyWith(color: theme.onSecondaryContainer);
        default:
          color = theme.surfaceContainerHighest;
          style = style?.copyWith(color: theme.onSurface);
      }
    } else {
      switch (kind) {
        case NotificationKind.error:
          color = Colors.redAccent;
        case NotificationKind.warning:
          color = Colors.deepOrangeAccent;
        default:
      }
    }

    final snackBar = SnackBar(
      content: Text(content, style: style),
      duration: const Duration(seconds: 3),
      showCloseIcon: true,
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
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
    String? channel,
  ) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          channel ?? 'helse',
          channel ?? 'helse',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          ticker: 'ticker',
        );
    NotificationDetails notificationDetails = NotificationDetails(
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
