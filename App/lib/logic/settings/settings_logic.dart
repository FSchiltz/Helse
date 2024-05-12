import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:helse/logic/settings/events_settings.dart';
import 'package:helse/logic/settings/health_settings.dart';
import 'package:helse/logic/settings/metrics_settings.dart';
import 'package:helse/logic/settings/ordered_item.dart';
import 'package:helse/logic/settings/theme_settings.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/account.dart';
import '../../services/setting_service.dart';
import '../../ui/common/date_range_picker.dart';

class SettingsBloc extends Cubit<bool> {
  SettingsBloc(super.initialState);

  void changed() {
    emit(true);
  }
}

class SettingsLogic {
  static final storage = SharedPreferences.getInstance();
  final Account _account;
  final SettingsBloc events = SettingsBloc(false);
  final SettingsBloc metrics = SettingsBloc(false);

  SettingsLogic(Account account) : _account = account;

  SettingService api() => SettingService(_account);

  static Future<HealthSettings> getHealth() async {
    var encoded = (await storage).getString(Account.health);
    if (encoded == null) {
      return HealthSettings(false);
    }

    return HealthSettings.fromJson(json.decode(encoded));
  }

  static Future<void> saveHealth(HealthSettings localSettings) async {
    await (await storage).setString(Account.health, json.encode(localSettings.toJson()));
  }

  static Future<ThemeSettings> getTheme() async {
    var encoded = (await storage).getString(Account.theme);
    if (encoded == null) {
      return ThemeSettings(ThemeMode.system);
    }

    return ThemeSettings.fromJson(json.decode(encoded));
  }

  static Future<void> saveTheme(ThemeSettings localSettings) async {
    await (await storage).setString(Account.theme, json.encode(localSettings.toJson()));
  }

  static Future<MetricsSettings> getMetrics() async {
    var encoded = (await storage).getString(Account.metrics);
    if (encoded == null) {
      return MetricsSettings([]);
    }

    return MetricsSettings.fromJson(json.decode(encoded));
  }

  Future<void> saveMetrics(MetricsSettings localSettings) async {
    await _saveMetrics(localSettings);
    metrics.changed();
  }

  static Future<void> _saveMetrics(MetricsSettings localSettings) async {
    await (await storage).setString(Account.metrics, json.encode(localSettings.toJson()));
  }

  static Future<EventsSettings> getEvents() async {
    var encoded = (await storage).getString(Account.events);
    if (encoded == null) {
      return EventsSettings([]);
    }

    return EventsSettings.fromJson(json.decode(encoded));
  }

  Future<void> saveEvents(EventsSettings localSettings) async {
    await _saveEvents(localSettings);
    events.changed();
  }

  static Future<void> _saveEvents(EventsSettings localSettings) async {
    await (await storage).setString(Account.events, json.encode(localSettings.toJson()));
  }

  static Future<void> setLastRun(String run) async {
    await (await storage).setString(Account.fitRun, run);
  }

  static Future<void> removeLastRun() async {
    await (await storage).remove(Account.fitRun);
  }

  static Future<String?> getLastRun() async {
    return (await storage).getString(Account.fitRun);
  }

  static Future<void> setDateRange(DatePreset run) async {
    await (await storage).setString(Account.dateRange, run.name);
  }

  static Future<DatePreset> getDateRange() async {
    var encoded = (await storage).getString(Account.dateRange);
    if (encoded == null) {
      return DatePreset.today;
    }

    return DatePreset.values.firstWhereOrNull((value) => value.name == encoded) ?? DatePreset.today;
  }

  static Future<void> updateMetrics(List<MetricType> model) async {
    var metrics = await getMetrics();
    for (var metric in model) {
      var existing = metrics.metrics.firstWhereOrNull((element) => element.name == metric.name);
      if (existing != null) {
        // already there, just update the name
        existing.name = metric.name ?? '';
      } else {
        if (metric.id != null) {
          metrics.metrics.add(OrderedItem(metric.id!, metric.name ?? '', GraphKind.bar, GraphKind.line));
        }
      }
    }

    await _saveMetrics(metrics);
  }

  static Future<void> updateEvents(List<EventType> model) async {
    var events = await getEvents();
    for (var event in model) {
      var existing = events.events.firstWhereOrNull((element) => element.name == event.name);
      if (existing != null) {
        // already there, just update the name
        existing.name = event.name ?? '';
      } else {
        if (event.id != null) {
          events.events.add(OrderedItem(event.id!, event.name ?? '', GraphKind.event, GraphKind.event));
        }
      }
    }
    await _saveEvents(events);
  }
}
