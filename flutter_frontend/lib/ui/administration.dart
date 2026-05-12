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
    ),
    NavigationRailDestination(
      icon: Icon(Icons.person_search_sharp),
      selectedIcon: Icon(Icons.person),
      label: Text('Users'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.post_add_sharp),
      selectedIcon: Icon(Icons.analytics),
      label: Text('Metrics'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.event_repeat_sharp),
      selectedIcon: Icon(Icons.event),
      label: Text('Events'),
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
        title: Text(
          'Administrations',
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: theme.primary,
              child: NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                labelType: NavigationRailLabelType.all,
                destinations: _destinations,
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: _pages[_selectedIndex],
            ),
          ],
        ),
      ),
    );
  }
}
