import 'package:collection/collection.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/settings_services.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class LocalSettingService extends LocalService implements SettingService {
  LocalSettingService(super.account);

  @override
  Future<PatientsSettings> getPatientsSettings() async {
    var settings = Dependencies.logics.patientsSettings.patientsSettings();

    settings = settings.copyWith(
      $default: settings.$default ?? PatientSettings(),
      patients: settings.patients ?? [],
    );

    final metricTypes = await Dependencies.services.metric.metricsType(
      false,
      null,
    );
    final metricGroups = await Dependencies.services.metric.metricsGroup();
    final eventTypes = await Dependencies.services.event.eventsType(false);

    final patients = <PatientSettings>[];

    for (final patient in settings.patients!) {
      patients.add(
        updatePatient(patient, metricTypes, metricGroups, eventTypes),
      );
    }

    return settings.copyWith(
      $default: updatePatient(
        settings.$default,
        metricTypes,
        metricGroups,
        eventTypes,
      ),
      patients: patients,
    );
  }

  @override
  Future<UserSettings> getPersonSettings() async {
    var settings = Dependencies.logics.settings.userSettings();

    settings = settings.copyWith(
      metricSettings:
          settings.metricSettings ?? MetricSettings(displaySettings: []),
      groups: settings.groups ?? MetricGroupSettings(displaySettings: []),
      eventSettings:
          settings.eventSettings ??
          EventSettings(displaySettings: [], displayValueSettings: []),
    );

    final metricTypes = await Dependencies.services.metric.metricsType(
      false,
      null,
    );

    updateMetrics(settings.metricSettings!.displaySettings, metricTypes ?? []);

    final metricGroups = await Dependencies.services.metric.metricsGroup();
    updateMetricGroups(settings.groups!.displaySettings, metricGroups ?? []);

    // update the events
    final eventTypes = await Dependencies.services.event.eventsType(false);
    updateEvents(settings.eventSettings!.displaySettings, eventTypes ?? []);

    return settings;
  }

  @override
  Future<Gotify> gotify() async => Gotify();

  @override
  Future<Oauth> oauth() async => Oauth();

  @override
  Future<Proxy> proxy() async => Proxy();

  @override
  Future<void> savePatientsSettings(PatientsSettings settings) async {}

  @override
  Future<void> savePersonSettings(UserSettings settings) async {}

  @override
  Future<Smtp> smtp() async => Smtp();

  @override
  Future<void> updateGotify(Gotify settings) async {}

  @override
  Future<void> updateOauth(Oauth settings) async {}

  @override
  Future<void> updateProxy(Proxy settings) async {}

  @override
  Future<void> updateSmtp(Smtp settings) async {}

  void updateMetrics(
    List<OrderedItem> displaySettings,
    List<MetricType> metricTypes,
  ) {
    final data = displaySettings.toList();
    displaySettings.clear();
    for (var metric in metricTypes) {
      var existing = data.firstWhereOrNull(
        (element) => element.id == metric.id,
      );
      if (existing != null) {
        displaySettings.add(
          existing.copyWith(name: metric.name, parent: metric.groupId),
        );
      } else {
        displaySettings.add(
          Dependencies.logics.settings.getDefaultMetricType(metric),
        );
      }
    }
  }

  void updateMetricGroups(
    List<OrderedItem> displaySettings,
    List<Group> metricGroups,
  ) {
    final data = displaySettings.toList();
    displaySettings.clear();
    for (final group in metricGroups) {
      final existing = data.firstWhereOrNull(
        (element) => element.id == group.id,
      );
      if (existing != null) {
        displaySettings.add(existing.copyWith(name: group.name));
      } else {
        displaySettings.add(
          Dependencies.logics.settings.getDefaultGroupType(group),
        );
      }
    }
  }

  void updateEvents(
    List<OrderedItem> displaySettings,
    List<EventType> eventTypes,
  ) {
    final data = displaySettings.toList();
    displaySettings.clear();
    for (final event in eventTypes) {
      final existing = data.firstWhereOrNull(
        (element) => element.id == event.id,
      );
      if (existing != null) {
        displaySettings.add(
          existing.copyWith(name: event.name, parent: event.groupId),
        );
      } else {
        displaySettings.add(
          Dependencies.logics.settings.getDefaultEventType(event),
        );
      }
    }
  }

  PatientSettings updatePatient(
    PatientSettings? settings,
    List<MetricType>? metricTypes,
    List<Group>? metricGroups,
    List<EventType>? eventTypes,
  ) {
    settings =
        settings?.copyWith(
          metricSettings:
              settings.metricSettings ?? MetricSettings(displaySettings: []),
          groups: settings.groups ?? MetricGroupSettings(displaySettings: []),
          eventSettings:
              settings.eventSettings ??
              EventSettings(displaySettings: [], displayValueSettings: []),
        ) ??
        PatientSettings(
          eventSettings: EventSettings(
            displaySettings: [],
            displayValueSettings: [],
          ),
          groups: MetricGroupSettings(displaySettings: []),
          metricSettings: MetricSettings(displaySettings: []),
        );

    updateMetrics(settings.metricSettings!.displaySettings, metricTypes ?? []);
    updateMetricGroups(settings.groups!.displaySettings, metricGroups ?? []);
    updateEvents(settings.eventSettings!.displaySettings, eventTypes ?? []);

    return settings;
  }
}
