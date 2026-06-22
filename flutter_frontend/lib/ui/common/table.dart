import 'package:flutter/material.dart';
import 'package:helse/ui/common/ui_constants.dart';

class Header {
  final String label;
  final double width;

  Header(this.label, this.width);
}

class RowData {
  final double width;
  final Widget child;

  RowData({required this.width, required this.child});
}

class TableHeader extends StatelessWidget {
  final List<Header> header;

  const TableHeader({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.outlineVariant)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: UIConstants.formPad,
        vertical: UIConstants.tablePad,
      ),
      child: Row(
        children: header
            .map((e) => SizedBox(width: e.width, child: Text(e.label)))
            .toList(),
      ),
    );
  }
}

class TableRow extends StatelessWidget {
  final List<RowData> row;

  const TableRow(this.row, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.outlineVariant)),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.formPad,
        vertical: UIConstants.tablePad,
      ),
      child: Row(
        children: row
            .map((e) => SizedBox(width: e.width, child: e.child))
            .toList(),
      ),
    );
  }
}
