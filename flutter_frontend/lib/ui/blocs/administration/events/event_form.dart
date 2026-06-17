import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/inputs/custom_switch.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../common/inputs/square_text_field.dart';

class EventAddForm extends StatelessWidget {
  final TextEditingController controllerDescription;
  final TextEditingController controllerName;
  final FocusNode focusNodeName = FocusNode();
  final FocusNode focusNodeDescription = FocusNode();

  final void Function(bool value) visibleCallback;
  final bool visible;

  EventAddForm({
    super.key,
    required this.controllerDescription,
    required this.controllerName,
    required this.visible,
    required this.visibleCallback,
  });

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return Column(
      children: [
        SquareTextField(
          controller: controllerName,
          focusNode: focusNodeName,
          label: locale.name,
          icon: Icons.person_sharp,
          validator: validateName,
          onEditingComplete: () => focusNodeDescription.requestFocus(),
        ),
        const SizedBox(height: UIConstants.formPad),
        SquareTextField(
          controller: controllerDescription,
          focusNode: focusNodeDescription,
          label: locale.description,
          icon: Icons.person_sharp,
        ),
        const SizedBox(height: UIConstants.formPad),
        HelseSwitch("Visible: ", visible, visibleCallback),
      ],
    );
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a name.";
    }

    return null;
  }
}
