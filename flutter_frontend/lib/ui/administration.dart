import 'package:flutter/material.dart';
import 'package:helse/ui/blocs/administration/event_settings.dart';
import 'package:helse/ui/blocs/administration/general_settings.dart';
import 'package:helse/ui/blocs/administration/metric_settings.dart';
import 'package:helse/ui/blocs/administration/user_settings.dart';
import 'package:helse/ui/common/menu_destination.dart';
import 'package:helse/ui/common/navigation_page.dart';

class AdministrationPage extends StatelessWidget {
  const AdministrationPage({super.key});

  static const List<MenuDestination> _destinations = [
    MenuDestination(
      icon: Icon(Icons.settings_sharp),
      selectedIcon: Icon(Icons.settings),
      label: 'General',
    ),
    MenuDestination(
      icon: Icon(Icons.person_search_sharp),
      selectedIcon: Icon(Icons.person),
      label: 'Users',
    ),
    MenuDestination(
      icon: Icon(Icons.post_add_sharp),
      selectedIcon: Icon(Icons.analytics),
      label: 'Metrics',
    ),
    MenuDestination(
      icon: Icon(Icons.event_repeat_sharp),
      selectedIcon: Icon(Icons.event),
      label: 'Events',
    ),
  ];

  static final List<Widget> _pages = [
    const GeneralSettings(),
    const UserSettings(),
    const MetricSettings(),
    const EventSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationPage('Administrations', pages: _pages, menu: _destinations);
  }
}
