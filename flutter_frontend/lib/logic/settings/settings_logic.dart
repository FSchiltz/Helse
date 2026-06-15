import 'dart:convert';
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

  static const fitRun = "fitLastRun";
  static const fitHistory = "fitHistory";
  static const fitBackground = "fitBackground";
  static const fitStatus = 'fitStatus';
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

  void saveHealth(HealthSettings localSettings) async {
    save(health, localSettings.toJson());
  }

  InterfaceTheme getTheme() {
    return (_userSettings()).theme ?? InterfaceTheme.system;
  }

  Future<void> saveTheme(InterfaceTheme theme) async {
    var settings = _userSettings();
    await _saveSettings(settings.copyWith(theme: theme), true);
    themebloc.changed(theme);
  }

  Future<void> _saveSettings(UserSettings settings, bool toServer) async {
    if (toServer) {
      await service.savePersonSettings(settings);
    }
    save(settingsName, settings.toJson());
    print("settings saved");
  }

  Future<void> loadSettings() async {
    var serverSettings = await service.getPersonSettings();
    print("Settings loaded from server");
    save(settingsName, serverSettings.toJson());
    init = true;
    Dependencies.theme.setColors(getColors());
    metrics.changed(true);
    events.changed(true);
    themebloc.changed(serverSettings.theme ?? InterfaceTheme.system);
  }

  UserSettings _userSettings() {
    var encoded = getString(settingsName);
    print("settings loaded");
    if (encoded == null) {
      return UserSettings();
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
    await _saveSettings(settings.copyWith(metricSettings: metric), toServer);
    metrics.changed(true);
  }

  EventSettings getEvents() {
    return (_userSettings()).eventSettings ??
        EventSettings(displaySettings: [], displayValueSettings: []);
  }

  Future<void> saveEvents(EventSettings events, bool toServer) async {
    var settings = _userSettings();
    await _saveSettings(settings.copyWith(eventSettings: events), toServer);
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
    await _saveSettings(settings.copyWith(datePreset: run), toServer);
  }

  DatePreset getDateRange() {
    var settings = _userSettings();
    return settings.datePreset ?? DatePreset.today;
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
}
