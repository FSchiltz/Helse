enum GraphKind {
  event,
  line,
  bar,
}

class OrderedItem {
  bool visible = true;
  int order = 0;
  String name;
  int id;
  GraphKind graph;

  OrderedItem(this.id, this.name, this.graph);

  OrderedItem.fromJson(dynamic json)
      : visible = json["visible"] as bool,
        id = json['id'] as int,
        order = json['order'] as int,
        name = json['name'] as String,
        graph = GraphKind.values.byName(json['graph'] as String);

  Map<String, dynamic> toJson() => {
        'visible': visible,
        'order': order,
        'name': name,
        'id': id,
        'graph': graph.name,
      };
}
