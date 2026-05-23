import 'package:flutter/material.dart';
import 'package:helse/ui/blocs/localSettings/metric_settings.dart';
import 'package:helse/ui/blocs/localSettings/event_settings.dart';
import 'package:helse/ui/blocs/localSettings/general_settings.dart';
import 'package:helse/ui/blocs/localSettings/sync_settings.dart';
import 'package:helse/ui/common/menu_destination.dart';
import 'package:helse/ui/common/navigation_page.dart';

class LocalSettingsPage extends StatelessWidget {
  const LocalSettingsPage({super.key});

  static final List<Widget> _pages = [
    GeneralSettings(),
    SyncSettings(),
    MetricSettings(),
    EventSettings(),
  ];

  static final List<MenuDestination> _destinations = [
    MenuDestination(
      icon: Icon(Icons.settings_sharp),
      selectedIcon: Icon(Icons.settings),
      label: 'General',
    ),
    MenuDestination(
      icon: Icon(Icons.person_search_sharp),
      selectedIcon: Icon(Icons.person_search),
      label: 'Health sync',
    ),
    MenuDestination(
      icon: Icon(Icons.post_add_sharp),
      selectedIcon: Icon(Icons.post_add),
      label: 'Metrics',
    ),
    MenuDestination(
      icon: Icon(Icons.event_repeat_sharp),
      selectedIcon: Icon(Icons.event),
      label: 'Events',
    ),
  ];

  @override
  Widget build(BuildContext context) {

    return NavigationPage('Local Settings', pages: _pages, menu: _destinations);
  }
}
