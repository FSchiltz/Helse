import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class OrderedEditItem {
  bool visible;
  bool showOnDashboard;
  int? order;
  String name;
  final int id;
  GraphKind? graph;
  GraphKind? detailGraph;
  final int? parent;

  factory OrderedEditItem.of(OrderedItem item) {
    return OrderedEditItem(
      visible: item.visible ?? true,
      name: item.name,
      id: item.id,
      showOnDashboard: item.showOnDashboard ?? true,
      detailGraph: item.detailGraph,
      graph: item.graph,
      order: item.order,
      parent: item.parent,
    );
  }

  OrderedEditItem({
    required this.visible,
    this.order,
    required this.name,
    required this.id,
    this.graph,
    this.detailGraph,
    required this.showOnDashboard,
    this.parent,
  });

  OrderedItem ordered() => OrderedItem(
    name: name,
    detailGraph: detailGraph,
    graph: graph,
    id: id,
    order: order,
    visible: visible,
    showOnDashboard: showOnDashboard,
    parent: parent,
  );
}
