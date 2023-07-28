import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function()? onTap;
  final Function(String)? onChanged;
  final TextEditingController _textController;
  final bool enable;

  TextInput(this.icon, this.label, {super.key, this.onTap, this.onChanged, TextEditingController? textController, this.enable = true}) : _textController = textController ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enable,
      controller: _textController,
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
