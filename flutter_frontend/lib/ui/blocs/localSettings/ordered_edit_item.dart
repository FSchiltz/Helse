import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class OrderedEditItem {
  bool visible;
  int? order;
  String name;
  final int id;
  GraphKind? graph;
  GraphKind? detailGraph;

  OrderedEditItem({
    required this.visible,
    this.order,
    required this.name,
    required this.id,
    this.graph,
    this.detailGraph,
  });

  OrderedItem ordered() => OrderedItem(
    name: name,
    detailGraph: detailGraph,
    graph: graph,
    id: id,
    order: order,
    visible: visible,
  );
}
