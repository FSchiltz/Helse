import 'package:flutter/material.dart';
import 'package:helse/logic/settings/ordered_item.dart';

import 'type_input.dart';

class OrderedList extends StatelessWidget {
  final List<OrderedItem> items;
  final bool withGraph;

  const OrderedList(this.items, {super.key, this.withGraph = false});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: items
          .map((item) => Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text('${item.name} :', style: theme.textTheme.titleLarge),
                  ),
                  Text("Visible: ", style: theme.textTheme.bodyMedium),
                  _StatefullCheck(item),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                    child: Text("Graph type", style: theme.textTheme.bodyMedium),
                  ),
                  SizedBox(
                    width: 160,
                    height: 45,
                    child: TypeInput(
                      GraphKind.values,
                      (value) => item.graph = value ?? item.graph,
                      label: 'Type',
                    ),
                  ),
                ]),
          ))
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
