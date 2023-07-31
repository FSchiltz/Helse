import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function()? onTap;
  final Function(String)? onChanged;

  const TextInput(this.icon, this.label, {super.key, this.onTap, this.onChanged });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
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
