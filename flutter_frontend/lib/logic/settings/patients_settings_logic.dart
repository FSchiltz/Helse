import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:helse/logic/settings/base_settings_logic.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class PatientsSettingsLogic extends BaseSettingsLogic {
  static const patientsName = 'patients';
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

    save(patientsName, full.toJson());
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
    var encoded = getString(patientsName);
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
      return object.$default ?? PatientSettings(version: settingsVersion);
    }
    var specificSettings = object.patients?.firstWhereOrNull(
      (e) => e.patientId == person,
    );

    return specificSettings ?? object.$default ?? PatientSettings(version: settingsVersion);
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

  Future<void> loadSettings() async {
    var serverSettings = await service.getPatientsSettings();
    print("Patients settings loaded from server");

    save(patientsName, serverSettings.toJson());
    init = true;
  }
}
