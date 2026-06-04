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
    PatientSettings settings,
    bool toServer,
  ) async {
    var full = await _patientsSettings();
    if (settings.patientId == null) {
      full = PatientsSettings($default: settings, patients: full.patients);
    } else {
      var patients =
          full.patients
              ?.where((e) => e.patientId != settings.patientId)
              .toList() ??
          [];
      patients.add(settings);
      full = PatientsSettings($default: full.$default, patients: patients);
    }

    if (toServer) {
      await service.savePatientsSettings(full);
    }

    (await storage).setString(Account.patients, json.encode(full.toJson()));
  }

  Future<void> saveMetrics(
    List<OrderedItem> metric,
    bool toServer,
    int? person,
  ) async {
    var settings = await _patientSettings(person);
    await _savePatientsSettings(
      PatientSettings(
        eventWidth: settings.eventWidth ?? 0,
        events: settings.events,
        metricGroups: settings.metricGroups,
        metrics: metric,
        theme: settings.theme ?? InterfaceTheme.system,
        datePreset: settings.datePreset ?? DatePreset.today,
        patientId: person,
      ),
      toServer,
    );
  }

  Future<void> saveMetricGroups(
    List<OrderedItem> metric,
    bool toServer,
    int? person,
  ) async {
    var settings = await _patientSettings(person);
    await _savePatientsSettings(
      PatientSettings(
        eventWidth: settings.eventWidth ?? 0,
        events: settings.events,
        metricGroups: metric,
        metrics: settings.metrics,
        theme: settings.theme ?? InterfaceTheme.system,
        datePreset: settings.datePreset ?? DatePreset.today,
        patientId: person,
      ),
      toServer,
    );
  }

  Future<void> saveEvents(
    List<OrderedItem> events,
    bool toServer,
    int? person,
  ) async {
    var settings = await _patientSettings(person);
    await _savePatientsSettings(
      PatientSettings(
        eventWidth: settings.eventWidth ?? 0,
        events: events,
        metricGroups: settings.metricGroups,
        metrics: settings.metrics,
        theme: settings.theme ?? InterfaceTheme.system,
        datePreset: settings.datePreset ?? DatePreset.today,
        patientId: person,
      ),
      toServer,
    );
  }

  Future<PatientsSettings> _patientsSettings() async {
    var encoded = (await storage).getString(Account.patients);
    if (encoded == null) {
      return PatientsSettings();
    }

    var map = json.decode(encoded) as Map<String, Object?>;
    var object = PatientsSettings.fromJson(map);
    return object;
  }

  Future<PatientSettings> _patientSettings(int? person) async {
    var object = await _patientsSettings();
    if (person == null) {
      return object.$default ?? PatientSettings();
    }
    var specificSettings = object.patients?.firstWhereOrNull(
      (e) => e.patientId == person,
    );

    return specificSettings ?? object.$default ?? PatientSettings();
  }

  Future<List<OrderedItem>> getMetrics(int? person) async {
    return (await _patientSettings(person)).metrics ?? [];
  }

  Future<List<OrderedItem>> getEvents(int? person) async {
    return (await _patientSettings(person)).events ?? [];
  }

  Future<List<OrderedItem>> getMetricGroups(int? person) async {
    return (await _patientSettings(person)).metricGroups ?? [];
  }

  Future<void> setDateRange(DatePreset run, int person) async {
    var settings = await _patientSettings(person);
    await _savePatientsSettings(
      PatientSettings(
        eventWidth: settings.eventWidth ?? 0,
        events: settings.events,
        metricGroups: settings.metricGroups,
        metrics: settings.metrics,
        theme: settings.theme ?? InterfaceTheme.system,
        datePreset: run,
        patientId: person,
      ),
      true,
    );
  }

  Future<DatePreset> getPatientsDateRange(int? person) async {
    var settings = await _patientSettings(person);
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
    var settings = await _patientsSettings();
    // update the default
    await _updateMetrics(settings.$default?.metrics ?? [], model, null);

    var patients = settings.patients;
    if (patients != null) {
      for (var patient in patients) {
        await _updateMetrics(patient.metrics ?? [], model, patient.patientId);
      }
    }
  }

  Future<void> updateEvents(List<EventType> model) async {
    var settings = await _patientsSettings();
    // update the default
    await _updateEvents(settings.$default?.events ?? [], model, null);

    var patients = settings.patients;
    if (patients != null) {
      for (var patient in patients) {
        await _updateEvents(patient.events ?? [], model, patient.patientId);
      }
    }
  }

  Future<void> updateMetricGroups(List<MetricGroup> model) async {
    var settings = await _patientsSettings();
    // update the default
    await _updateMetricGroups(
      settings.$default?.metricGroups ?? [],
      model,
      null,
    );

    var patients = settings.patients;
    if (patients != null) {
      for (var patient in patients) {
        await _updateMetricGroups(
          patient.metricGroups ?? [],
          model,
          patient.patientId,
        );
      }
    }
  }

  Future<void> _updateMetrics(
    List<OrderedItem> metrics,
    List<MetricType> model,
    int? patient,
  ) async {
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

    await saveMetrics(metrics, false, patient);
  }

  Future<void> _updateEvents(
    List<OrderedItem> events,
    List<EventType> model,
    int? patient,
  ) async {
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
    await saveEvents(newEvents, false, patient);
  }

  Future<void> _updateMetricGroups(
    List<OrderedItem> metrics,
    List<MetricGroup> model,
    int? patient,
  ) async {
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

    await saveMetricGroups(newMetrics, false, patient);
  }
}
