import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/logic/settings/base_settings_logic.dart';
import 'package:helse/logic/settings/health_settings.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class SettingsBloc<T> extends Cubit<T> {
  SettingsBloc(super.initialState);

  void changed(T value) {
    emit(value);
  }
}

class SettingsLogic extends BaseSettingsLogic {
  static const settingsName = 'settings';

  static const fitHistory = "fitHistory";
  static const fitBackground = "fitBackground";
  static const fitStatus = 'fitStatus';
  static const fitRun = "fitLastRun";
  static const health = 'health';

  final SettingsBloc<InterfaceTheme> themebloc = SettingsBloc(
    InterfaceTheme.system,
  );
  final SettingsBloc<bool> events = SettingsBloc(false);
  final SettingsBloc<bool> metrics = SettingsBloc(false);
  bool init = false;

  SettingsLogic(super.account, super.service);

  Future<HealthSettings> getHealth() async {
    var encoded = getString(health);
    if (encoded == null) {
      return HealthSettings(false, false, false);
    }

    return HealthSettings.fromJson(json.decode(encoded));
  }

  Future<void> saveHealth(HealthSettings localSettings) async {
    await save(health, localSettings.toJson());
  }

  InterfaceTheme getTheme() {
    return (_userSettings()).theme ?? InterfaceTheme.system;
  }

  Future<void> saveTheme(InterfaceTheme theme) async {
    var settings = _userSettings();
    await _saveSettings(settings.copyWith(theme: theme), true, #saveTheme);
    themebloc.changed(theme);
  }

  Future<void> _saveSettings(
    UserSettings settings,
    bool toServer,
    Symbol caller,
  ) async {
    if (toServer) {
      await service.savePersonSettings(settings);
    }
    await save(settingsName, settings.toJson());
    log("settings saved by $caller");
  }

  Future<void> loadSettings() async {
    var serverSettings = await service.getPersonSettings();
    log("Settings loaded from server", name: "Settings");
    await _saveSettings(serverSettings, false, #loadSettings);

    init = true;
    Dependencies.theme.loadColors(getColors());
    metrics.changed(true);
    events.changed(true);
    themebloc.changed(serverSettings.theme ?? InterfaceTheme.system);
  }

  UserSettings _userSettings() {
    var encoded = getString(settingsName);
    log("settings loaded", name: "Settings");
    if (encoded == null) {
      return UserSettings(version: settingsVersion);
    }

    var map = json.decode(encoded) as Map<String, Object?>;
    var object = UserSettings.fromJson(map);
    return object;
  }

  MetricSettings getMetrics() {
    var settings = _userSettings().metricSettings;
    return settings ??
        MetricSettings(
          displaySettings: [],
          groups: MetricGroupSettings(displaySettings: []),
        );
  }

  Future<void> saveMetrics(MetricSettings metric, bool toServer) async {
    var settings = _userSettings();
    await _saveSettings(
      settings.copyWith(metricSettings: metric),
      toServer,
      #saveMetrics,
    );
    metrics.changed(true);
  }

  EventSettings getEvents() {
    return (_userSettings()).eventSettings ??
        EventSettings(displaySettings: [], displayValueSettings: []);
  }

  Future<void> saveEvents(EventSettings events, bool toServer) async {
    var settings = _userSettings();
    await _saveSettings(
      settings.copyWith(eventSettings: events),
      toServer,
      #saveEvents,
    );
  }

  void setLastRun(String run) {
    setString(fitRun, run);
  }

  void removeLastRun() {
    remove(fitRun);
  }

  String? getLastRun() {
    return getString(fitRun);
  }

  Future<void> setColors(
    Map<StateType, Map<String, Color>> colors, {
    bool toServer = true,
  }) async {
    var settings = _userSettings();
    for (var group in colors.entries) {
      List<OrderedItem>? list;
      switch (group.key) {
        case StateType.events:
          list = settings.eventSettings?.displaySettings;
          if (list == null) {
            list = [];
            settings = settings.copyWith(
              eventSettings: settings.eventSettings?.copyWith(
                displaySettings: list,
              ),
            );
          }
        case StateType.metric:
          list = settings.metricSettings?.displaySettings;
          if (list == null) {
            list = [];
            settings = settings.copyWith(
              metricSettings: settings.metricSettings?.copyWith(
                displaySettings: list,
              ),
            );
          }
        case StateType.eventValue:
          list = settings.eventSettings?.displayValueSettings;
          if (list == null) {
            list = [];
            settings = settings.copyWith(
              eventSettings: settings.eventSettings?.copyWith(
                displayValueSettings: list,
              ),
            );
          }
        case StateType.metricGroup:
          list = settings.metricSettings?.groups?.displaySettings;
          if (list == null) {
            list = [];
            settings = settings.copyWith(
              metricSettings: settings.metricSettings?.copyWith(
                groups: settings.metricSettings?.groups?.copyWith(
                  displaySettings: list,
                ),
              ),
            );
          }
      }

      for (var entry in group.value.entries) {
        if (!list.any((e) => e.key == entry.key)) {
          list.add(
            OrderedItem(
              key: entry.key,
              color: entry.value.toARGB32(),
              id: 0,
              name: entry.key,
              detailGraph: GraphKind.text,
              graph: GraphKind.text,
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

    await _saveSettings(settings, toServer, #setColors);
  }

  Map<StateType, Map<String, Color>> getColors() {
    var settings = _userSettings();

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

  void setHasHistory(bool run) {
    setBool(fitHistory, run);
  }

  void setBackgroundAccess(bool authorized) {
    setBool(fitBackground, authorized);
  }

  bool? getHasHistory() {
    return getBool(fitHistory);
  }

  Future<void> setDateRange(DatePreset run, {bool toServer = true}) async {
    var settings = _userSettings();
    await _saveSettings(
      settings.copyWith(datePreset: run),
      toServer,
      #setDateRange,
    );
  }

  DatePreset getDateRange() {
    var settings = _userSettings();
    return settings.datePreset ?? DatePreset.today;
  }

  Map<String, Color> _map(List<OrderedItem> settings) {
    final Map<String, Color> map = {};
    for (var item in settings) {
      final color = item.color;
      map.putIfAbsent(item.key ?? item.id.toString(), () {
        if (color == null) {
          return ThemeHelper.randomColor();
        } else {
          return Color(color);
        }
      });
    }
    return map;
  }

  void setFitRun(String value) {
    setString(fitRun, value);
  }

  void setFitStatus(String text) {
    account.set(fitStatus, text);
  }

  String? getFirStatus() {
    return getString(fitStatus);
  }
}
