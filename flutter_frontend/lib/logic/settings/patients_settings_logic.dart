import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:helse/logic/settings/base_settings_logic.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

import '../../services/account.dart';

class PatientsSettingsLogic extends BaseSettingsLogic {
  bool init = false;

  PatientsSettingsLogic(super.account, super.service);

  Future<void> _savePatientsSettings(
    PatientSettings settings,
    bool toServer,
  ) async {
    var full = _patientsSettings();
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

    save(Account.patients, full.toJson());
  }

  Future<void> saveMetrics(
    MetricSettings metric,
    bool toServer,
    int? person,
  ) async {
    var settings = _patientSettings(person);
    await _savePatientsSettings(
      settings.copyWith(metricSettings: metric, patientId: person),
      toServer,
    );
  }

  Future<void> saveEvents(
    EventSettings events,
    bool toServer,
    int? person,
  ) async {
    var settings = _patientSettings(person);
    await _savePatientsSettings(
      settings.copyWith(eventSettings: events, patientId: person),
      toServer,
    );
  }

  PatientsSettings _patientsSettings() {
    var encoded = getString(Account.patients);
    if (encoded == null) {
      return PatientsSettings();
    }

    return PatientsSettings.fromJson(
      json.decode(encoded) as Map<String, Object?>,
    );
  }

  PatientSettings _patientSettings(int? person) {
    var object = _patientsSettings();
    if (person == null) {
      return object.$default ?? PatientSettings();
    }
    var specificSettings = object.patients?.firstWhereOrNull(
      (e) => e.patientId == person,
    );

    return specificSettings ?? object.$default ?? PatientSettings();
  }

  MetricSettings getMetrics(int? person) {
    return (_patientSettings(person)).metricSettings ??
        MetricSettings(displaySettings: []);
  }

  EventSettings getEvents(int? person) {
    return (_patientSettings(person)).eventSettings ??
        EventSettings(displaySettings: [], displayValueSettings: []);
  }

  Future<void> setDateRange(DatePreset run, int person) async {
    var settings = _patientSettings(person);
    await _savePatientsSettings(
      settings.copyWith(datePreset: run, patientId: person),
      true,
    );
  }

  DatePreset getPatientsDateRange(int? person) {
    var settings = _patientSettings(person);
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

  Future<void> updateMetrics(
    List<MetricType> model,
    List<MetricGroup> groups,
  ) async {
    var settings = _patientsSettings();
    // update the default
    await _updateMetrics(
      settings.$default?.metricSettings,
      model,
      groups,
      null,
    );

    var patients = settings.patients;
    if (patients != null) {
      for (var patient in patients) {
        await _updateMetrics(
          patient.metricSettings,
          model,
          groups,
          patient.patientId,
        );
      }
    }
  }

  Future<void> updateEvents(List<EventType> model) async {
    var settings = _patientsSettings();
    // update the default
    await _updateEvents(settings.$default?.eventSettings, model, null);

    var patients = settings.patients;
    if (patients != null) {
      for (var patient in patients) {
        await _updateEvents(patient.eventSettings, model, patient.patientId);
      }
    }
  }

  Future<void> _updateMetrics(
    MetricSettings? metrics,
    List<MetricType> model,
    List<MetricGroup> groups,
    int? patient,
  ) async {
    metrics ??= MetricSettings(displaySettings: []);
    for (var metric in model) {
      var existing = metrics.displaySettings.firstWhereOrNull(
        (element) => element.id == metric.id,
      );
      if (existing != null) {
        metrics.displaySettings.removeWhere((x) => x.id == metric.id);
        // already there, just update the name
        metrics.displaySettings.add(
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
        metrics.displaySettings.add(getDefault(metric));
      }
    }

    final groupSetting =
        metrics.groups ?? MetricGroupSettings(displaySettings: []);

    metrics = metrics.copyWith(groups: groupSetting);

    for (var metric in groups) {
      var existing = groupSetting.displaySettings.firstWhereOrNull(
        (element) => element.id == metric.id,
      );
      if (existing != null) {
        // already there, just update the name
        groupSetting.displaySettings.add(
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
          groupSetting.displaySettings.add(
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

    await saveMetrics(metrics, false, patient);
  }

  Future<void> _updateEvents(
    EventSettings? events,
    List<EventType> model,
    int? patient,
  ) async {
    events ??= EventSettings(displaySettings: [], displayValueSettings: []);
    final settings = events.displaySettings;
    for (var event in model) {
      var existing = settings.firstWhereOrNull(
        (element) => element.id == event.id,
      );
      if (existing != null) {
        // already there, just update the name
        events.displaySettings.add(
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
        events.displaySettings.add(
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

    await saveEvents(events, false, patient);
  }

  Future<void> loadSettings() async {
    var serverSettings = await service.getPatientsSettings();
    print("Patients settings loaded from server");

    serverSettings = _upgradeSettings(serverSettings);
    save(Account.settings, serverSettings.toJson());
    init = true;
  }

  PatientsSettings _upgradeSettings(PatientsSettings settings) {
    final version = settings.version ?? 0;
    if (version < 2) {
      // upgrade to version 2
      final base = settings.$default;
      final patients = settings.patients;

      settings = settings.copyWith(
        version: 2,
        $default: (base == null) ? null : _upgradeSetting(base, version),
        patients: (patients == null)
            ? null
            : patients.map((e) => _upgradeSetting(e, version)).toList(),
      );
    }

    return settings;
  }

  PatientSettings _upgradeSetting(PatientSettings settings, int version) {
    if (version < 2) {
      // upgrade to version 2
      settings = settings.copyWith(
        version: 2,
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
