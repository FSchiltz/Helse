import 'package:material_ui/material_ui.dart';
import 'package:helse/helpers/selection_controller.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/detail/event_data_table.dart';
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
          : EventDataTable(
              count: widget.selection.selected.length,
              person: widget.person,
              type: widget.type,
              reset: widget.reset,
              state: state,
              callback: (page, count) async {
                return widget.selection.selected
                    .skip(page * count)
                    .take(count)
                    .toList();
              },
            ),
    );
  }
}
