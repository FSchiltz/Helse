import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/localSettings/metric_settings.dart';
import 'package:helse/ui/blocs/localSettings/event_settings.dart';
import 'package:helse/ui/common/menu_destination.dart';
import 'package:helse/ui/common/navigation_page.dart';

class PatientSettingsPage extends StatelessWidget {
  const PatientSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var locale = Translation.locale(context);
    return NavigationPage(
      locale.patientsSettings,
      pages: [MetricSettings(isPatient: true), EventSettings(isPatient: true)],
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
