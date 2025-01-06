import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
import 'package:helse/ui/common/square_text_field.dart';

import '../../../common/statefull_check.dart';
import '../../../common/type_input.dart';

class MetricAddForm extends StatelessWidget {
  final TextEditingController controllerUnit;
  final TextEditingController controllerName;
  final TextEditingController controllerDescription;
  final void Function(MetricSummary? value) summaryCallback;
  final void Function(MetricDataType? value) typeCallback;
  final MetricSummary? summary;
  final MetricDataType? type;

  final void Function(bool value) visibleCallback;
  final bool visible;

  final FocusNode focusNodeName = FocusNode();
  final FocusNode focusNodeDescription = FocusNode();
  final FocusNode focusNodeUnit = FocusNode();

  MetricAddForm({
    super.key,
    required this.controllerUnit,
    required this.controllerName,
    required this.controllerDescription,
    required this.summaryCallback,
    required this.typeCallback,
    required this.summary,
    required this.type,
    required this.visible,
    required this.visibleCallback,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return Column(
      children: [
        SquareTextField(
          theme: theme,
          icon: Icons.person_sharp,
          controller: controllerName,
          focusNode: focusNodeName,
          label: "Name",
          validator: validateName,
          onEditingComplete: () => focusNodeDescription.requestFocus(),
        ),
        const SizedBox(height: 10),
        SquareTextField(
          icon: Icons.person_sharp,
          theme: theme,
          controller: controllerDescription,
          focusNode: focusNodeDescription,
          label: "Description",
          onEditingComplete: () => focusNodeUnit.requestFocus(),
        ),
        const SizedBox(height: 10),
        SquareTextField(controller: controllerUnit, icon: Icons.email_sharp, focusNode: focusNodeUnit, theme: theme, label: "Unit"),
        const SizedBox(height: 10),
        TypeInput(
          value: type,
          MetricDataType.values.map((x) => DropDownItem(x, x.name)).toList(),
          (value) => typeCallback.call(value),
          label: 'Type',
        ),
        const SizedBox(height: 10),
        TypeInput(
          value: summary,
          MetricSummary.values.map((x) => DropDownItem(x, x.name)).toList(),
          (value) => summaryCallback.call(value),
          label: 'Summary',
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            const Text("Visible: "),
            StatefullCheck(visible, visibleCallback),
          ]),
        ),
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
