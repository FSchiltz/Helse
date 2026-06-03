import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:helse/services/setting_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/account.dart';

class PatientsSettingsLogic {
  static final storage = SharedPreferences.getInstance();
  final Account account;
  final SettingService service;
  bool init = false;

  PatientsSettingsLogic(this.account, this.service);

  Future<void> _savePatientsSettings(
    PatientsSettings settings,
    bool toServer,
  ) async {
    if (toServer) {
      await service.savePatientsSettings(settings);
    }

    (await storage).setString(Account.patients, json.encode(settings.toJson()));
  }

  Future<void> saveMetrics(
    List<OrderedItem> metric,
    bool toServer,
  ) async {
    var settings = await _patientSettings();
    var d = settings.$default ?? PatientSettings();
    await _savePatientsSettings(
      PatientsSettings(
        $default: PatientSettings(
          eventWidth: d.eventWidth ?? 0,
          events: d.events,
          metricGroups: d.metricGroups,
          metrics: metric,
          theme: d.theme ?? InterfaceTheme.system,
          datePreset: d.datePreset ?? DatePreset.today,
          patientId: 0,
        ),
      ),
      toServer,
    );
  }

  Future<void> saveMetricGroups(
    List<OrderedItem> metric,
    bool toServer,
  ) async {
    var settings = await _patientSettings();
    var d = settings.$default ?? PatientSettings(patientId: 0);
    await _savePatientsSettings(
      PatientsSettings(
        $default: PatientSettings(
          eventWidth: d.eventWidth ?? 0,
          events: d.events,
          metricGroups: metric,
          metrics: d.metrics,
          theme: d.theme ?? InterfaceTheme.system,
          datePreset: d.datePreset ?? DatePreset.today,
          patientId: 0,
        ),
      ),
      toServer,
    );
  }

  Future<void> saveEvents(
    List<OrderedItem> events,
    bool toServer,
  ) async {
    var settings = await _patientSettings();
    var d = settings.$default ?? PatientSettings(patientId: 0);
    await _savePatientsSettings(
      PatientsSettings(
        $default: PatientSettings(
          eventWidth: d.eventWidth ?? 0,
          events: events,
          metricGroups: d.metricGroups,
          metrics: d.metrics,
          theme: d.theme ?? InterfaceTheme.system,
          datePreset: d.datePreset ?? DatePreset.today,
          patientId: 0,
        ),
      ),
      toServer,
    );
  }

  Future<PatientsSettings> _patientSettings() async {
    var encoded = (await storage).getString(Account.patients);
    if (encoded == null) {
      return PatientsSettings();
    }

    var map = json.decode(encoded) as Map<String, Object?>;
    var object = PatientsSettings.fromJson(map);

    return object;
  }

  Future<List<OrderedItem>> getMetrics() async {
    return (await _patientSettings()).$default?.metrics ?? [];
  }

  Future<List<OrderedItem>> getEvents() async {
    return (await _patientSettings()).$default?.events ?? [];
  }

  Future<List<OrderedItem>> getMetricGroups() async {
    return (await _patientSettings()).$default?.metricGroups ?? [];
  }

  Future<void> setDateRange(DatePreset run) async {
    var settings = await _patientSettings();
    var d = settings.$default ?? PatientSettings(patientId: 0);
    await _savePatientsSettings(
      PatientsSettings(
        $default: PatientSettings(
          eventWidth: d.eventWidth ?? 0,
          events: d.events,
          metricGroups: d.metricGroups,
          metrics: d.metrics,
          theme: d.theme ?? InterfaceTheme.system,
          datePreset: run,
          patientId: 0,
        ),
      ),
      true,
    );
  }

  Future<DatePreset> getPatientsDateRange() async {
    var settings = await _patientSettings();
    return settings.$default?.datePreset ?? DatePreset.today;
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
      );
    }

    return OrderedItem(
      id: item.id,
      name: item.name,
      graph: GraphKind.text,
      detailGraph: GraphKind.text,
      visible: item.visible,
      showOnDashboard: true,
    );
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
}
