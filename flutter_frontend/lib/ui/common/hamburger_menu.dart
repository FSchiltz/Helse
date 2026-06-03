import 'package:flutter/material.dart';

class MenuButton {
  final String label;
  final IconData icon;
  final void Function() callback;
  MenuButton(this.label, this.icon, this.callback);
}

class HamburgerMenu extends StatefulWidget {
  final List<MenuButton> items;
  const HamburgerMenu({super.key, required this.items});

  @override
  State<HamburgerMenu> createState() => _MenuState();
}

class _MenuState extends State<HamburgerMenu> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  final MenuController _controller = MenuController();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return MenuAnchor(
      controller: _controller,
      childFocusNode: _buttonFocusNode,
      builder: (context, controller, child) => IconButton(
        focusNode: _buttonFocusNode,
        onPressed: () {
          if (_controller.isOpen) {
            controller.close();
          } else {
            controller.open();
          }
        },
        icon: Icon(Icons.menu),
      ),
      menuChildren: widget.items
          .map(
            (e) => Container(
              margin: EdgeInsets.all(8),
              child: ElevatedButton.icon(
                label: Text(e.label),
                onPressed: e.callback,
                icon: Icon(e.icon, color: theme.primary),
              ),
            ),
          )
          .toList(),
    );
  }
}
