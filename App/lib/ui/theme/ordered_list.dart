import 'package:flutter/material.dart';
import 'package:helse/logic/settings/ordered_item.dart';

class OrderedList extends StatelessWidget {
  final List<OrderedItem> items;

  const OrderedList(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: items
          .map((item) => Row(children: [
                Text(item.name),
                _StatefullCheck(item),
              ]))
          .toList(),
    );
  }
}

class _StatefullCheck extends StatefulWidget {
  const _StatefullCheck(this.items);

  final OrderedItem items;

  @override
  State<_StatefullCheck> createState() => _StatefullCheckState();
}

class _StatefullCheckState extends State<_StatefullCheck> {
  late bool check = widget.items.visible;
  @override
  Widget build(BuildContext context) {
    return Checkbox(
        value: check,
        onChanged: (value) {
          setState(() {
            check = value ?? false;
          });
          widget.items.visible = value ?? false;
        });
  }
}
