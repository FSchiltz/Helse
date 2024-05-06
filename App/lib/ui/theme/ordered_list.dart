import 'package:flutter/material.dart';
import 'package:helse/logic/settings/ordered_item.dart';

class OrderedList extends StatelessWidget {
  final List<OrderedItem> items;

  const OrderedList(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Row(children: [
          Text(items[index].name),
          _StatefullCheck(items[index]),
        ]);
      },
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
