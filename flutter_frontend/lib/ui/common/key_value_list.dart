import 'package:flutter/material.dart';
import 'package:helse/ui/common/ui_constants.dart';

class KeyValue {
  final String label;
  final String? value;
  final IconData? icon;
  final List<KeyValue>? children;

  const KeyValue(this.label, {this.value, this.children, this.icon});
}

class _KeyValueRow {
  final String label;
  final String? value;
  final int depth;
  final IconData? icon;

  const _KeyValueRow({
    required this.label,
    this.value,
    required this.depth,
    this.icon,
  });
}

class KeyValueList extends StatelessWidget {
  final List<KeyValue> items;

  const KeyValueList(this.items, {super.key});

  List<_KeyValueRow> _flatten(List<KeyValue> items, [int depth = 0]) {
    return items.expand((item) {
      return [
        _KeyValueRow(
          label: item.label,
          value: item.value,
          depth: depth,
          icon: item.icon,
        ),
        ..._flatten(item.children ?? const [], depth + 1),
      ];
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = _flatten(items);

    return Table(
      columnWidths: const {
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
      children: rows.map((row) {
        return TableRow(
          children: [
            _buildLabel(context, row),
            Padding(
              padding: const EdgeInsets.only(
                top: UIConstants.tablePad,
                bottom: UIConstants.tablePad,
                left: UIConstants.formPad,
              ),
              child: Text(row.value ?? '', style: theme.textTheme.bodyMedium),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildLabel(BuildContext context, _KeyValueRow row) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: UIConstants.tablePad,
        horizontal: UIConstants.tablePad,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < row.depth; i++)
              SizedBox(
                width: 16,
                child: Center(
                  child: Container(
                    width: 2,
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
              ),
            if (row.icon != null)
              Padding(
                padding: const EdgeInsets.only(right: UIConstants.tablePad),
                child: Icon(row.icon, size: 16),
              ),
            Expanded(child: Text(row.label, style: theme.textTheme.bodyLarge)),
            const SizedBox(width: UIConstants.tablePad),
          ],
        ),
      ),
    );
  }
}
