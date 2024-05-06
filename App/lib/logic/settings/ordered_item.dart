class OrderedItem {
  bool visible = true;
  int order = 0;
  String name;
  int id;

  OrderedItem(this.id, this.name);

  OrderedItem.fromJson(dynamic json)
      : visible = json["visible"] as bool,
        id = json['id'] as int,
        order = json['order'] as int,
        name = json['name'] as String;

  Map<String, dynamic> toJson() => {
        'visible': visible,
        'order': order,
        'name': name,
        'id': id,
      };
}
