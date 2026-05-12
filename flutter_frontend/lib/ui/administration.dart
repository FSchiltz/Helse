import 'package:flutter/material.dart';
import 'package:helse/ui/blocs/administration/event_settings.dart';
import 'package:helse/ui/blocs/administration/general_settings.dart';
import 'package:helse/ui/blocs/administration/metric_settings.dart';
import 'package:helse/ui/blocs/administration/user_settings.dart';

class AdministrationPage extends StatefulWidget {
  const AdministrationPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const AdministrationPage());
  }

  @override
  State<AdministrationPage> createState() => _AdministrationPageState();
}

class _AdministrationPageState extends State<AdministrationPage> {
  int _selectedIndex = 0;

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
      label: Text('Users'),
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

  static final List<Widget> _pages = [
    const GeneralSettings(),
    const UserSettings(),
    const MetricSettings(),
    const EventSettings(),
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
            'Administrations',
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Expanded(
              child: _pages[_selectedIndex],
            ),
          ],
        ),
      ),
    );
  }
}
