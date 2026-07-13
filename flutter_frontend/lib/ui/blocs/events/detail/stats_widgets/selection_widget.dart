import 'package:flutter/material.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/event_helper.dart';
import 'package:helse/helpers/selection_controller.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/layout/common_card.dart';

class SelectionWidget extends StatefulWidget {
  const SelectionWidget({
    super.key,
    required this.reset,
    required this.person,
    required this.type,
    required this.selection,
  });

  final void Function() reset;
  final SelectionController<Event> selection;
  final int? person;
  final EventType type;

  @override
  State<SelectionWidget> createState() => _SelectionWidgetState();
}

class _SelectionWidgetState extends State<SelectionWidget> {
  bool state = false;

  @override
  void initState() {
    super.initState();
    widget.selection.addListener(
      () => setState(() {
        state = !state;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: widget.selection.selected.isEmpty
          ? SizedBox.shrink()
          : Column(
              children: widget.selection.selected
                  .map(
                    (e) => EventTile(
                      e,
                      widget.type,
                      widget.reset,
                      person: widget.person,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class EventTile extends StatelessWidget {
  final Event event;
  final void Function() reset;
  final int? person;
  final EventType type;

  const EventTile(this.event, this.type, this.reset, {super.key, this.person});

  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('Selected: '),
        Text('(${event.id})'),
        Text(' ${event.description} '),
        Text(
          locale
              .range(
                DateHelper.format(event.start.toLocal(), context: context),
                DateHelper.format(event.stop.toLocal(), context: context),
              )
              .toLowerCase(),
        ),
        if (event.tag != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(event.tag.toString()),
          ),

        ...EventHelper.getButtons(
          event,
          type,
          reset,
          person: person,
          context: context,
        ),
      ],
    );
  }
}
