import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:helse/logic/settings/base_settings_logic.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class PatientsSettingsLogic extends BaseSettingsLogic {
  static const patientsName = 'patients';
  bool init = false;

  PatientsSettingsLogic(super.account, super.service);

  Future<void> savePatientsSettings(
    PatientSettings settings,
    bool toServer,
  ) async {
    var full = patientsSettings();
    if (settings.patientId == null) {
      full = full.copyWith($default: settings, patients: full.patients);
    } else {
      var patients =
          full.patients
              ?.where((e) => e.patientId != settings.patientId)
              .toList() ??
          [];
      patients.add(settings);
      full = full.copyWith($default: full.$default, patients: patients);
    }

    if (toServer) {
      await service.savePatientsSettings(full);
    }

    await save(patientsName, full.toJson());
  }

  Future<void> saveMetrics(
    MetricSettings metric,
    bool toServer,
    int? person,
  ) async {
    var settings = patientSettings(person);
    await savePatientsSettings(
      settings.copyWith(metricSettings: metric, patientId: person),
      toServer,
    );
  }

  Future<void> saveEvents(
    EventSettings events,
    bool toServer,
    int? person,
  ) async {
    var settings = patientSettings(person);
    await savePatientsSettings(
      settings.copyWith(eventSettings: events, patientId: person),
      toServer,
    );
  }

  PatientsSettings patientsSettings() {
    var encoded = getString(patientsName);
    if (encoded == null) {
      return PatientsSettings();
    }

    return PatientsSettings.fromJson(
      json.decode(encoded) as Map<String, Object?>,
    );
  }

  PatientSettings patientSettings(int? person) {
    var object = patientsSettings();
    if (person == null) {
      return object.$default ?? PatientSettings(version: settingsVersion);
    }
    var specificSettings = object.patients?.firstWhereOrNull(
      (e) => e.patientId == person,
    );

    return specificSettings ??
        object.$default ??
        PatientSettings(version: settingsVersion);
  }

  MetricSettings getMetrics(int? person) {
    return (patientSettings(person)).metricSettings ??
        MetricSettings(displaySettings: []);
  }

  EventSettings getEvents(int? person) {
    return (patientSettings(person)).eventSettings ??
        EventSettings(displaySettings: [], displayValueSettings: []);
  }

  Future<void> setDateRange(DatePreset run, int person) async {
    var settings = patientSettings(person);
    await savePatientsSettings(
      settings.copyWith(datePreset: run, patientId: person),
      true,
    );
  }

  DatePreset getPatientsDateRange(int? person) {
    var settings = patientSettings(person);
    return settings.datePreset ?? DatePreset.today;
  }

  Future<void> loadSettings() async {
    var serverSettings = await service.getPatientsSettings();
    log("Patients settings loaded from server", name: "Settings");

    await save(patientsName, serverSettings.toJson());
    init = true;
  }
}
