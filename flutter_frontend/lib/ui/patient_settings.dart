import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/localSettings/metric_settings.dart';
import 'package:helse/ui/blocs/localSettings/event_settings.dart';
import 'package:helse/ui/common/menu_destination.dart';
import 'package:helse/ui/common/layout/navigation_page.dart';

class PatientSettingsPage extends StatelessWidget {
  final int? person;
  final List<Person>? patients;
  const PatientSettingsPage(this.person, {super.key, this.patients});

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    var theme = Theme.of(context).textTheme;
    var settings = Dependencies.logics.patientsSettings.getSettings();
    return NavigationPage(
      header: (person == null)
          ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: AlignmentGeometry.topLeft,
              child: Text(
                  "Default settings for the patients. Patients ${settings.patients?.map((e) => patients?.firstWhereOrNull((x) => x.id == e.patientId)?.name).join(',')} are overrided",
                  style: theme.headlineSmall,
                ),
            ),
          )
          : null,
      locale.patientsSettings,
      pages: [
        MetricsSettings(isPatient: true, patient: person),
        EventsSettings(isPatient: true, patient: person),
      ],
      menu: [
        MenuDestination(
          icon: Icon(Icons.post_add_sharp),
          selectedIcon: Icon(Icons.post_add),
          label: locale.metrics,
        ),
        MenuDestination(
          icon: Icon(Icons.event_repeat_sharp),
          selectedIcon: Icon(Icons.event),
          label: locale.events,
        ),
      ],
    );
  }
}
