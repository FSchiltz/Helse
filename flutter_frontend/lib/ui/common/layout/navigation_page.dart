import 'package:flutter/material.dart';
import 'package:helse/ui/common/menu_destination.dart';
import 'package:helse/ui/common/ui_constants.dart';

class NavigationPage extends StatefulWidget {
  final String title;
  final List<Widget> pages;
  final List<MenuDestination> menu;
  final Widget? header;

  const NavigationPage(
    this.title, {
    super.key,
    required this.pages,
    required this.menu,
    this.header,
  });

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    var media = MediaQuery.of(context);
    double screenWidth = media.size.width;
    var aspectRatio = media.size.aspectRatio;

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
      drawer: (screenWidth < UIConstants.displaymedium && aspectRatio > 1)
          ? Drawer(
              child: NavigationRail(
                extended: true,
                elevation: 1,
                backgroundColor: theme.surfaceContainerHigh,
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                labelType: NavigationRailLabelType.none,
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
            )
          : null,

      bottomNavigationBar:
          (screenWidth < UIConstants.displaymedium && aspectRatio <= 1)
          ? BottomNavigationBar(
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
            )
          : null,
      body: SafeArea(child: _tabs(screenWidth, theme)),
    );
  }

  Widget _tabs(double screenWidth, ColorScheme theme) {
    return (screenWidth >= UIConstants.displaymedium)
        ? _menuBar(
            widget.menu,
            widget.pages[_selectedIndex],
            theme.surfaceContainerHigh,
          )
        : _body(widget.pages[_selectedIndex]);
  }

  Widget _menuBar(List<MenuDestination> menu, Widget content, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NavigationRail(
          backgroundColor: color,
          scrollable: true,
          useIndicator: true,

          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          labelType: NavigationRailLabelType.all,
          destinations: menu
              .map(
                (e) => NavigationRailDestination(
                  icon: e.icon,
                  label: Text(e.label),
                  padding: EdgeInsetsDirectional.all(12),
                  selectedIcon: e.selectedIcon,
                ),
              )
              .toList(),
        ),
        Expanded(child: _body(content)),
      ],
    );
  }

  Widget _body(Widget content) {
    if (widget.header != null) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          widget.header!,
          Expanded(child: content),
        ],
      );
    }
    return content;
  }
}
