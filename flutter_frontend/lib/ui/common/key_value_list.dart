import 'package:flutter/material.dart';
import 'package:helse/ui/common/ui_constants.dart';

class KeyValue {
  final String label;
  final String? value;
  final List<KeyValue>? values;

  const KeyValue(this.label, {this.value, this.values});
}

class KeyValueList extends StatelessWidget {
  final List<KeyValue> list;
  const KeyValueList(this.list, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
      },
      border: TableBorder(
        horizontalInside: BorderSide(
          color: theme.colorScheme.outlineVariant,
          width: 0.3,
        ),
        verticalInside: BorderSide(
          color: theme.colorScheme.outlineVariant,
          width: 2,
        ),
      ),
      children: list
          .map(
            (e) => TableRow(
              children: [
                Align(
                  alignment: AlignmentGeometry.centerEnd,
                  child: Padding(
                    padding: const EdgeInsets.all(UIConstants.formPad),
                    child: Text(e.label, style: theme.textTheme.bodyLarge),
                  ),
                ),

                (e.values != null)
                    ? KeyValueList(e.values ?? [])
                    : Align(
                        alignment: AlignmentGeometry.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(UIConstants.formPad),
                          child: Text(
                            e.value ?? '',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
              ],
            ),
          )
          .toList(),
    );
  }
}
