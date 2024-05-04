import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
import 'package:helse/ui/helpers/square_outline_input_border.dart';

class TypeInput extends StatelessWidget {
  final List<UserType> types;
  final void Function(UserType?) callback;

  const TypeInput(this.types, this.callback, {super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return DropdownButtonFormField(
      onChanged: callback,
      items: types
          .map((type) => DropdownMenuItem(value: type, child: Text(type.name)))
          .toList(),
      decoration: InputDecoration(
        labelText: 'Type',
        prefixIcon: const Icon(Icons.list_sharp),
        prefixIconColor: theme.primary,
        filled: true,
        fillColor: theme.surface,
        border: SquareOutlineInputBorder(theme.primary),
      ),
    );
  }
}
