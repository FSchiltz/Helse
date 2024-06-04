import 'package:flutter/material.dart';
import 'package:helse/ui/common/square_outline_input_border.dart';

class DropDownItem<T> {
  final T value;
  final String description;

  const DropDownItem(this.value, this.description);
}

class TypeInput<T> extends StatelessWidget {
  final List<DropDownItem<T>> types;
  final void Function(T?) callback;
  final String? label;
  final T? value;

  const TypeInput(this.types, this.callback, {super.key, this.label, this.value});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return DropdownButtonFormField(
      onChanged: callback,
      value: value,
      items: types.map((type) => DropdownMenuItem(value: type.value, child: Text(type.description))).toList(),
      decoration: InputDecoration(
        labelText: label ?? 'Type',
        prefixIcon: const Icon(Icons.list_sharp),
        prefixIconColor: theme.primary,
        filled: true,
        fillColor: theme.surface,
        border: SquareOutlineInputBorder(theme.primary),
      ),
    );
  }
}
