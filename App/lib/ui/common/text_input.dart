import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final IconData icon;
  final String label;
  final void Function()? onTap;
  final void Function(String)? onChanged;

  const TextInput(this.icon, this.label, {super.key, this.onTap, this.onChanged});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return TextField(
      onChanged: onChanged,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        prefixIconColor: theme.primary,
        filled: true,
        fillColor: theme.surface,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primary),
        ),
      ),
    );
  }
}
