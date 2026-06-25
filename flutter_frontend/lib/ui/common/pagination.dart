import 'dart:math';

import 'package:flutter/material.dart';
import 'package:helse/ui/common/ui_constants.dart';

class Pagination extends StatelessWidget {
  final int count;
  final int pageSize;
  final int page;
  final void Function(int) callBack;
  final List<Widget> menu;
  final int selected;
  const Pagination({
    super.key,
    required this.count,
    required this.pageSize,
    required this.page,
    required this.callBack,
    required this.menu,
    this.selected = 0,
  });

  @override
  Widget build(BuildContext context) {
    final int maxPage = (count / pageSize).toInt();
    return Row(
      spacing: UIConstants.formPad,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (maxPage > 1) ...[
          IconButton(
            onPressed: page <= 0 ? null : () => callBack(max(0, page - 1)),
            icon: Icon(Icons.arrow_left),
            iconSize: 40,
            padding: EdgeInsets.all(2),
          ),
          Text('${page + 1} / ${maxPage + 1} pages'),
          Text('-'),
        ],
        Text('$count items'),
        if (selected > 0) Text('$selected selected'),
        if (maxPage > 1)
          IconButton(
            onPressed: page >= maxPage
                ? null
                : () => callBack(min(maxPage, page + 1)),
            icon: Icon(Icons.arrow_right),
            iconSize: 40,
            padding: EdgeInsets.all(2),
          ),

        ...menu,
      ],
    );
  }
}
