import 'dart:math';

import 'package:flutter/material.dart';
import 'package:helse/ui/common/ui_constants.dart';

class Pagination extends StatelessWidget {
  final int count;
  final int pageSize;
  final int page;
  final void Function(int) callBack;
  const Pagination({
    super.key,
    required this.count,
    required this.pageSize,
    required this.page,
    required this.callBack,
  });

  @override
  Widget build(BuildContext context) {
    final int maxPage = (count / pageSize).toInt();
    return Row(
      children: [
        IconButton(
          onPressed: () => callBack(max(0, page - 1)),
          icon: Icon(Icons.arrow_left),
        ),
        Text(page.toString()),
        SizedBox(width: UIConstants.formPad),
        Text(count.toString()),
        IconButton(
          onPressed: () => callBack(min(maxPage, page + 1)),
          icon: Icon(Icons.arrow_right),
        ),
      ],
    );
  }
}
