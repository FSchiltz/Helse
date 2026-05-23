import 'package:flutter/material.dart';
import 'package:helse/ui/common/menu_destination.dart';

class NavigationPage extends StatefulWidget {
  final String title;
  final List<Widget> pages;
  final List<MenuDestination> menu;

  const NavigationPage(
    this.title, {
    super.key,
    required this.pages,
    required this.menu,
  });

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
      ),
      drawer: (screenWidth <= 600)
          ? null
          : Drawer(
              child: NavigationRail(
                backgroundColor: theme.surfaceContainerHigh,
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                labelType: NavigationRailLabelType.all,
                destinations: widget.menu
                    .map(
                      (e) => NavigationRailDestination(
                        icon: e.icon,
                        label: Text(e.label),
                        selectedIcon: e.selectedIcon,
                        padding: EdgeInsetsDirectional.all(12),
                      ),
                    )
                    .toList(),
              ),
            ),

      bottomNavigationBar: (screenWidth > 600)
          ? null
          : BottomNavigationBar(
              backgroundColor: theme.surfaceContainerHigh,
              onTap: (index) {
                {
                  setState(() {
                    _selectedIndex = index;
                  });
                }
              },
              unselectedItemColor: theme.onSurface,
              selectedItemColor: theme.secondary,
              currentIndex: _selectedIndex,
              items: widget.menu
                  .map(
                    (e) => BottomNavigationBarItem(
                      icon: e.icon,
                      label: e.label,
                      activeIcon: e.selectedIcon,
                      backgroundColor: theme.surfaceBright,
                    ),
                  )
                  .toList(),
            ),
      body: SafeArea(child: widget.pages[_selectedIndex]),
    );
  }
}
