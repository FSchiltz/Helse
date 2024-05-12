import 'package:flutter/material.dart';
import 'package:helse/ui/common/square_outline_input_border.dart';

class TypeInput<T extends Enum> extends StatelessWidget {
  final List<T> types;
  final void Function(T?) callback;
  final String? label;

  const TypeInput(this.types, this.callback, {super.key, this.label});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return DropdownButtonFormField(
      onChanged: callback,
      items: types.map((type) => DropdownMenuItem(value: type, child: Text(type.name))).toList(),
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
