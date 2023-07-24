import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final Function(String)? _onChanged;
  final IconData _icon;
  final String _label;

  const TextInput(Function(String)? onChanged, IconData icon,  String label, {super.key})
      : _onChanged = onChanged,
        _icon = icon,
        _label = label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: _onChanged,
      decoration: InputDecoration(
        labelText: _label,
        prefixIcon: Icon(_icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
