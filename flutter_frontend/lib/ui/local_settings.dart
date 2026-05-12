import 'package:flutter/material.dart';
import 'package:helse/ui/blocs/localSettings/metric_settings.dart';
import 'package:helse/ui/blocs/localSettings/event_settings.dart';
import 'package:helse/ui/blocs/localSettings/general_settings.dart';
import 'package:helse/ui/blocs/localSettings/sync_settings.dart';

class LocalSettingsPage extends StatefulWidget {
  const LocalSettingsPage({super.key});

  @override
  State<LocalSettingsPage> createState() => _LocalSettingsPageState();
}

class _LocalSettingsPageState extends State<LocalSettingsPage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    GeneralSettings(),
    SyncSettings(),
    MetricSettings(),
    EventSettings(),
  ];

  static const List<NavigationRailDestination> _destinations = [
    NavigationRailDestination(
      icon: Icon(Icons.settings_sharp),
      selectedIcon: Icon(Icons.settings),
      label: Text('General'),
      padding: EdgeInsetsDirectional.all(12),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.person_search_sharp),
      selectedIcon: Icon(Icons.person),
      label: Text('Health sync'),
      padding: EdgeInsetsDirectional.all(12),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.post_add_sharp),
      selectedIcon: Icon(Icons.analytics),
      label: Text('Metrics'),
      padding: EdgeInsetsDirectional.all(12),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.event_repeat_sharp),
      selectedIcon: Icon(Icons.event),
      label: Text('Events'),
      padding: EdgeInsetsDirectional.all(12),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Local Settings',
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
      ),
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              backgroundColor: theme.surfaceContainerHigh,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: _destinations,
            ),
            Expanded(child: _pages[_selectedIndex]),
          ],
        ),
      ),
    );
  }
}
