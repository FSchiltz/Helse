import 'package:helse/logic/settings/ordered_item.dart';

class EventsSettings {
  static const _events = "events";
  List<OrderedItem> events;

  EventsSettings(this.events);

  // stupid boilerplate code because dart can't decode json
  EventsSettings.fromJson(dynamic json)
      : events = (json[_events] as List<dynamic>? ?? [])
            .map((e) => OrderedItem.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() => {
        _events: events,
      };
}
