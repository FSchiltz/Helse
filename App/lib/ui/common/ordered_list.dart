import 'package:flutter/material.dart';
import 'package:helse/logic/settings/ordered_item.dart';
import 'package:helse/ui/common/statefull_check.dart';

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
                child: Column(
                  children: [
                    Row(children: [Text(item.name, style: theme.textTheme.titleLarge)]),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        Text("Visible: ", style: theme.textTheme.bodyLarge),
                        StatefullCheck(item.visible, (value) => item.visible = value),
                      ]),
                    ),
                    if (withGraph)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text("Graph type", style: theme.textTheme.bodyLarge),
                          ),
                          SizedBox(
                            width: 160,
                            height: 45,
                            child: TypeInput(
                              value: item.graph,
                              GraphKind.values,
                              (value) => item.graph = value ?? item.graph,
                              label: 'Type',
                            ),
                          ),
                        ]),
                      ),
                    if (withGraph)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text("Detail graph type", style: theme.textTheme.bodyLarge),
                          ),
                          SizedBox(
                            width: 160,
                            height: 45,
                            child: TypeInput(
                              value: item.detailGraph,
                              GraphKind.values,
                              (value) => item.detailGraph = value ?? item.detailGraph,
                              label: 'Type',
                            ),
                          ),
                        ]),
                      ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
