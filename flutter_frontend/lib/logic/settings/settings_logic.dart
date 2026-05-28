import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:helse/logic/settings/health_settings.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/account.dart';
import '../../services/setting_service.dart';

class SettingsBloc extends Cubit<bool> {
  SettingsBloc(super.initialState);

  void changed() {
    emit(true);
  }
}

class SettingsLogic {
  static final storage = SharedPreferences.getInstance();
  final Account account;
  final SettingsBloc events = SettingsBloc(false);
  final SettingsBloc metrics = SettingsBloc(false);

  SettingsLogic(this.account);

  SettingService api() => SettingService(account);

  Future<HealthSettings> getHealth() async {
    var encoded = (await storage).getString(Account.health);
    if (encoded == null) {
      return HealthSettings(false);
    }

    return HealthSettings.fromJson(json.decode(encoded));
  }

  Future<void> saveHealth(HealthSettings localSettings) async {
    await (await storage).setString(
      Account.health,
      json.encode(localSettings.toJson()),
    );
  }

  Future<InterfaceTheme> getTheme() async {
    return (await _userSettings()).theme ?? InterfaceTheme.system;
  }

  Future<void> saveTheme(InterfaceTheme theme) async {
    var settings = await _userSettings();
    await _saveSettings(
      UserSettings(
        eventWidth: settings.eventWidth,
        events: settings.events,
        metricGroups: settings.metricGroups,
        metrics: settings.metrics,
        theme: theme,
      ),
    );
  }

  Future<void> _saveSettings(UserSettings settings) async {
    (await storage).setString(Account.settings, json.encode(settings.toJson()));
  }

  Future<UserSettings> _userSettings() async {
    var encoded = (await storage).getString(Account.settings);
    if (encoded == null) {
      return UserSettings();
    }
    return UserSettings.fromJson(json.decode(encoded));
  }

  Future<List<OrderedItem>> getMetrics() async {
    return (await _userSettings()).metrics ?? [];
  }

  Future<void> saveMetrics(List<OrderedItem> metric) async {
    var settings = await _userSettings();
    await _saveSettings(
      UserSettings(
        eventWidth: settings.eventWidth,
        events: settings.events,
        metricGroups: settings.metricGroups,
        metrics: metric,
        theme: settings.theme,
      ),
    );
    metrics.changed();
  }

  Future<List<OrderedItem>> getEvents() async {
    return (await _userSettings()).events ?? [];
  }

  Future<void> saveEvents(List<OrderedItem> events) async {
    var settings = await _userSettings();
    await _saveSettings(
      UserSettings(
        eventWidth: settings.eventWidth,
        events: events,
        metricGroups: settings.metricGroups,
        metrics: settings.metrics,
        theme: settings.theme,
      ),
    );
  }

  Future<void> setLastRun(String run) async {
    await (await storage).setString(Account.fitRun, run);
  }

  Future<void> removeLastRun() async {
    await (await storage).remove(Account.fitRun);
  }

  Future<String?> getLastRun() async {
    return (await storage).getString(Account.fitRun);
  }

  Future<void> setDateRange(DatePreset run) async {
    var settings = await _userSettings();
    await _saveSettings(
      UserSettings(
        eventWidth: settings.eventWidth,
        events: settings.events,
        metricGroups: settings.metricGroups,
        metrics: settings.metrics,
        theme: settings.theme,
        datePreset: run,
      ),
    );
  }

  Future<DatePreset> getDateRange() async {
    return (await _userSettings()).datePreset ?? DatePreset.today;
  }

  Future<void> updateMetrics(List<MetricType> model) async {
    var metrics = await getMetrics();
    List<OrderedItem> newMetrics = [];
    for (var metric in model) {
      var existing = metrics.firstWhereOrNull(
        (element) => element.id == metric.id,
      );
      if (existing != null) {
        // already there, just update the name
        newMetrics.add(
          OrderedItem(
            name: metric.name,
            detailGraph: existing.detailGraph,
            graph: existing.graph,
            id: existing.id,
            order: existing.order,
            visible: existing.visible,
          ),
        );
      } else {
        if (metric.id != null) {
          newMetrics.add(getDefault(metric));
        }
      }
    }

    await saveMetrics(metrics);
  }

  Future<void> updateEvents(List<EventType> model) async {
    var events = await getEvents();
    List<OrderedItem> newEvents = [];
    for (var event in model) {
      var existing = events.firstWhereOrNull(
        (element) => element.id == event.id,
      );
      if (existing != null) {
        // already there, just update the name
        newEvents.add(
          OrderedItem(
            name: event.name,
            detailGraph: existing.detailGraph,
            graph: existing.graph,
            id: existing.id,
            order: existing.order,
            visible: existing.visible,
          ),
        );
      } else {
        if (event.id != null) {
          events.add(
            OrderedItem(
              id: event.id!,
              name: event.name,
              graph: GraphKind.text,
              detailGraph: GraphKind.text,
              visible: event.visible,
            ),
          );
        }
      }
    }
    await saveEvents(events);
  }

  OrderedItem getDefault(MetricType item) {
    if (item.type == MetricDataType.number) {
      return OrderedItem(
        id: item.id ?? 0,
        name: item.name,
        graph: GraphKind.bar,
        detailGraph: GraphKind.line,
        visible: item.visible,
      );
    }

    return OrderedItem(
      id: item.id ?? 0,
      name: item.name,
      graph: GraphKind.text,
      detailGraph: GraphKind.text,
      visible: item.visible,
    );
  }

  Future<void> saveMetricGroups(List<OrderedItem> metric) async {
    var settings = await _userSettings();
    await _saveSettings(
      UserSettings(
        eventWidth: settings.eventWidth,
        events: settings.events,
        metricGroups: metric,
        metrics: settings.metrics,
        theme: settings.theme,
      ),
    );
    metrics.changed();
  }

  Future<List<OrderedItem>> getMetricGroups() async {
    return (await _userSettings()).metricGroups ?? [];
  }

  Future<void> updateMetricGroups(List<MetricGroup> model) async {
    var metrics = await getMetricGroups();
    List<OrderedItem> newMetrics = [];
    for (var metric in model) {
      var existing = metrics.firstWhereOrNull(
        (element) => element.id == metric.id,
      );
      if (existing != null) {
        // already there, just update the name
        newMetrics.add(
          OrderedItem(
            name: metric.name,
            id: existing.id,
            detailGraph: existing.detailGraph,
            graph: existing.graph,
            order: existing.order,
            visible: existing.visible,
          ),
        );
      } else {
        if (metric.id != null) {
          newMetrics.add(
            OrderedItem(
              id: metric.id!,
              name: metric.name,
              graph: GraphKind.bar,
              detailGraph: GraphKind.line,
            ),
          );
        }
      }
    }

    await saveMetricGroups(metrics);
  }
}
