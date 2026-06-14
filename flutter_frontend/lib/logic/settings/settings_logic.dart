import 'dart:convert';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/logic/settings/health_settings.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/services/setting_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/account.dart';

class SettingsBloc<T> extends Cubit<T> {
  SettingsBloc(super.initialState);

  void changed(T value) {
    emit(value);
  }
}

class SettingsLogic {
  static final storage = SharedPreferences.getInstance();
  final Account account;
  final SettingsBloc<InterfaceTheme> themebloc = SettingsBloc(
    InterfaceTheme.system,
  );
  final SettingsBloc<bool> events = SettingsBloc(false);
  final SettingsBloc<bool> metrics = SettingsBloc(false);
  final SettingService service;
  bool init = false;

  SettingsLogic(this.account, this.service);

  Future<HealthSettings> getHealth() async {
    var encoded = (await storage).getString(Account.health);
    if (encoded == null) {
      return HealthSettings(false, false, false);
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
        eventWidth: settings.eventWidth ?? 0,
        events: settings.events,
        metricGroups: settings.metricGroups,
        metrics: settings.metrics,
        theme: theme,
        datePreset: settings.datePreset ?? DatePreset.today,
      ),
      true,
    );
    themebloc.changed(theme);
  }

  Future<void> _saveSettings(UserSettings settings, bool toServer) async {
    if (toServer) {
      await service.savePersonSettings(settings);
    }

    (await storage).setString(Account.settings, json.encode(settings.toJson()));
  }

  Future<void> loadSettings() async {
    var serverSettings = await service.getPersonSettings();
    print("Settings loaded from server");

    serverSettings = _upgradeSettings(serverSettings);

    (await storage).setString(
      Account.settings,
      json.encode(serverSettings.toJson()),
    );
    init = true;
    Dependencies.theme.setColors(await getColors());
    metrics.changed(true);
    events.changed(true);
    themebloc.changed(serverSettings.theme ?? InterfaceTheme.system);
  }

  Future<UserSettings> _userSettings() async {
    var encoded = (await storage).getString(Account.settings);
    if (encoded == null) {
      return UserSettings();
    }

    var map = json.decode(encoded) as Map<String, Object?>;
    var object = UserSettings.fromJson(map);

    return object;
  }

  Future<List<OrderedItem>> getMetrics() async {
    return (await _userSettings()).metrics ?? [];
  }

  Future<void> saveMetrics(List<OrderedItem> metric, bool toServer) async {
    var settings = await _userSettings();
    await _saveSettings(settings.copyWith(metrics: metric), toServer);
    metrics.changed(true);
  }

  Future<List<OrderedItem>> getEvents() async {
    return (await _userSettings()).events ?? [];
  }

  Future<void> saveEvents(List<OrderedItem> events, bool toServer) async {
    var settings = await _userSettings();
    await _saveSettings(settings.copyWith(events: events), toServer);
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

  Future<void> setColors(
    Map<StateType, Map<String, Color>> colors, {
    bool toServer = true,
  }) async {
    var settings = await _userSettings();
    for (var group in colors.entries) {
      List<OrderedItem>? list;
      switch (group.key) {
        case StateType.events:
          list = settings.eventSettings?.displaySettings;
          if (list == null) {
            list = [];
            settings = settings.copyWith(
              eventSettings: EventSettings(
                displaySettings: list,
                displayValueSettings: [],
              ),
            );
          }
        case StateType.metric:
          list = settings.metricSettings?.displaySettings;
          if (list == null) {
            list = [];
            settings = settings.copyWith(
              metricSettings: MetricSettings(
                displaySettings: list,
                groups: MetricGroupSettings(displaySettings: []),
              ),
            );
          }
        case StateType.eventValue:
          list = settings.eventSettings?.displayValueSettings;
          if (list == null) {
            list = [];
            settings = settings.copyWith(
              eventSettings: EventSettings(
                displaySettings: [],
                displayValueSettings: list,
              ),
            );
          }
        case StateType.metricGroup:
          list = settings.metricSettings?.groups?.displaySettings;
          if (list == null) {
            list = [];
            settings = settings.copyWith(
              metricSettings: MetricSettings(
                displaySettings: [],
                groups: MetricGroupSettings(displaySettings: list),
              ),
            );
          }
      }
      final newList = <OrderedItem>[];
      for (var entry in list) {
        // update the correct map
        var color = group.value.entries.firstWhereOrNull(
          (e) => e.key == (entry.key ?? entry.id.toString()),
        );
        if (color != null) {
          entry = entry.copyWith(color: color.value.toARGB32());
        }
        newList.add(entry);
      }
      list.clear();
      list.addAll(newList);
    }

    await _saveSettings(settings, toServer);

    Dependencies.theme.setColors(colors);
  }

  Future<Map<StateType, Map<String, Color>>> getColors() async {
    var settings = await _userSettings();

    Map<StateType, Map<String, Color>> map = {};
    map[StateType.events] = _map(settings.eventSettings?.displaySettings ?? []);
    map[StateType.eventValue] = _map(
      settings.eventSettings?.displayValueSettings ?? [],
    );
    map[StateType.metric] = _map(
      settings.metricSettings?.displaySettings ?? [],
    );
    map[StateType.metricGroup] = _map(
      settings.metricSettings?.groups?.displaySettings ?? [],
    );

    return map;
  }

  Future<void> setHasHistory(bool run) async {
    await (await storage).setBool(Account.fitHistory, run);
  }

  Future<void> setBackgroundAccess(bool authorized) async {
    await (await storage).setBool(Account.fitBackground, authorized);
  }

  Future<bool?> getHasHistory() async {
    return (await storage).getBool(Account.fitHistory);
  }

  Future<void> setDateRange(DatePreset run, {bool toServer = true}) async {
    var settings = await _userSettings();
    await _saveSettings(settings.copyWith(datePreset: run), toServer);
  }

  Future<DatePreset> getDateRange() async {
    var settings = await _userSettings();
    return settings.datePreset ?? DatePreset.today;
  }

  Future<void> updateMetrics(List<MetricType> model) async {
    var metrics = await getMetrics();
    for (var metric in model) {
      var existing = metrics.firstWhereOrNull(
        (element) => element.id == metric.id,
      );
      if (existing != null) {
        metrics.removeWhere((x) => x.id == metric.id);
        // already there, just update the name
        metrics.add(
          OrderedItem(
            name: metric.name,
            detailGraph: existing.detailGraph,
            graph: existing.graph,
            id: existing.id,
            order: existing.order,
            visible: existing.visible,
            showOnDashboard: existing.showOnDashboard,
            parent: metric.groupId,
          ),
        );
      } else {
        metrics.add(getDefault(metric));
      }
    }

    await saveMetrics(metrics, false);
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
            showOnDashboard: existing.showOnDashboard,
          ),
        );
      } else {
        newEvents.add(
          OrderedItem(
            id: event.id,
            name: event.name,
            graph: GraphKind.text,
            detailGraph: GraphKind.text,
            visible: event.visible,
            showOnDashboard: true,
          ),
        );
      }
    }
    await saveEvents(newEvents, false);
  }

  OrderedItem getDefault(MetricType item) {
    if (item.type == MetricDataType.number) {
      return OrderedItem(
        id: item.id,
        name: item.name,
        graph: GraphKind.bar,
        detailGraph: GraphKind.line,
        visible: item.visible,
        showOnDashboard: true,
        parent: item.groupId,
      );
    }

    return OrderedItem(
      id: item.id,
      name: item.name,
      graph: GraphKind.text,
      detailGraph: GraphKind.text,
      visible: item.visible,
      showOnDashboard: true,
      parent: item.groupId,
    );
  }

  Future<void> saveMetricGroups(List<OrderedItem> metric, bool toServer) async {
    var settings = await _userSettings();
    await _saveSettings(settings.copyWith(metricGroups: metric), toServer);
    metrics.changed(true);
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
            showOnDashboard: existing.showOnDashboard,
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
              visible: true,
              showOnDashboard: metric.showOnDashboard ?? true,
            ),
          );
        }
      }
    }

    await saveMetricGroups(newMetrics, false);
  }

  Map<String, Color> _map(List<OrderedItem> settings) {
    final Map<String, Color> map = {};
    for (var item in settings) {
      final color = item.color;
      if (color != null) {
        map.putIfAbsent(item.key ?? item.id.toString(), () => Color(color));
      }
    }
    return map;
  }

  UserSettings _upgradeSettings(UserSettings settings) {
    final version = settings.version ?? 0;
    if (version == 0) {
      // upgrade to version 1
      settings = settings.copyWith(
        eventSettings: EventSettings(
          displaySettings: settings.events ?? [],
          displayValueSettings: [],
        ),
        metricSettings: MetricSettings(
          displaySettings: settings.metrics ?? [],
          groups: MetricGroupSettings(
            displaySettings: settings.metricGroups ?? [],
          ),
        ),
      );
    }
    
    return settings;
  }
}
