import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/localSettings/metric_settings.dart';
import 'package:helse/ui/blocs/localSettings/event_settings.dart';
import 'package:helse/ui/blocs/localSettings/general_settings.dart';
import 'package:helse/ui/blocs/localSettings/sync_settings.dart';
import 'package:helse/ui/common/menu_destination.dart';
import 'package:helse/ui/common/navigation_page.dart';

class LocalSettingsPage extends StatelessWidget {
  const LocalSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return NavigationPage(
      locale.localSettings,
      pages: [
        GeneralSettings(),
        SyncSettings(),
        MetricSettings(),
        EventSettings(),
      ],
      menu: [
        MenuDestination(
          icon: Icon(Icons.settings_sharp),
          selectedIcon: Icon(Icons.settings),
          label: locale.general,
        ),
        MenuDestination(
          icon: Icon(Icons.person_search_sharp),
          selectedIcon: Icon(Icons.person_search),
          label: locale.healthsync,
        ),
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
