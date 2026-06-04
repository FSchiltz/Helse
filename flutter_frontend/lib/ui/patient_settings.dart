import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/localSettings/metric_settings.dart';
import 'package:helse/ui/blocs/localSettings/event_settings.dart';
import 'package:helse/ui/common/menu_destination.dart';
import 'package:helse/ui/common/navigation_page.dart';

class PatientSettingsPage extends StatelessWidget {
  final int? person;
  const PatientSettingsPage(this.person, {super.key});

  @override
  Widget build(BuildContext context) {
    var locale = Translation.locale(context);
    return NavigationPage(
      locale.patientsSettings,
      pages: [
        MetricSettings(isPatient: true, patient: person),
        EventSettings(isPatient: true, patient: person),
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
