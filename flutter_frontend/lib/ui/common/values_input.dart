import 'package:flutter/material.dart';
import 'package:helse/ui/common/square_outline_input_border.dart';

class DropdownItem<T> {
  final T value;
  final String description;

  const DropdownItem(this.value, this.description);
}

class ValuesInput<T> extends StatelessWidget {
  final List<DropdownItem<T>> types;
  final void Function(T?) callback;
  final String? label;
  final T? value;
  final IconData? icon;

  const ValuesInput(
    this.types,
    this.callback, {
    super.key,
    this.label,
    this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return DropdownButtonFormField(
      onChanged: callback,
      initialValue: value,
      items: types
          .map(
            (type) => DropdownMenuItem(
              value: type.value,
              child: Text(type.description),
            ),
          )
          .toList(),
      decoration: InputDecoration(
        labelText: label ?? 'Type',
        prefixIcon: Icon(icon ?? Icons.list_sharp),
        prefixIconColor: theme.primary,
        isDense: true,
        filled: true,
        fillColor: theme.surface,
        border: SquareOutlineInputBorder(theme.primary),
        contentPadding: null,
      ),
    );
  }
}
