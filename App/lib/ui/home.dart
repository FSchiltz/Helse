import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'settings.dart';

class DataModel {
  final String label;
  final IconData icon;
  const DataModel({required this.label, required this.icon});
}

enum DeviceType {
  Mobile,
  Tablet,
  Desktop,
}

class Home extends StatefulWidget {
  const Home({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const Home());
  }

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var selectedIndex = 0;
  List<DataModel> dataList = [
    const DataModel(
      label: "Home",
      icon: Icons.home,
    ),
    const DataModel(
      label: "Settings",
      icon: Icons.settings,
    )
  ];

  DeviceType getDevice() {
    return MediaQuery.of(context).size.width <= 800 ? DeviceType.Mobile : DeviceType.Desktop;
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const Dashboard();
        break;
      case 1:
        page = const SettingsPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        bottomNavigationBar: getDevice() == DeviceType.Mobile
            ? BottomNavigationBar(
                onTap: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
                items: dataList.map((e) => BottomNavigationBarItem(backgroundColor: Colors.black, icon: Icon(e.icon), label: e.label)).toList(),
              )
            : null,
        body: Row(
          children: [
            if (getDevice() == DeviceType.Desktop)
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 1080,
                  destinations: dataList.map((e) => NavigationRailDestination(icon: Icon(e.icon), label: Text(e.label))).toList(),
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}
