import 'package:flutter/material.dart';
import 'package:helse/ui/blocs/events/detail/event_file_list.dart';
import 'package:helse/ui/common/inputs/files/file_list_widget.dart';
import 'package:helse/ui/common/popup_submit_state.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/inputs/custom_switch.dart';
import 'package:helse/ui/common/inputs/square_text_field.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../di/dependencies.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../common/inputs/date_input.dart';
import '../../common/layout/square_dialog.dart';

class EventAdd extends StatefulWidget {
  final void Function() callback;
  final EventType type;
  final int? person;
  final Event? edit;

  const EventAdd(this.type, this.callback, {super.key, this.person, this.edit});

  @override
  State<EventAdd> createState() => _EventAddState();
}

class _EventAddState extends PopupSubmitState<EventAdd> {
  DateTime _start = DateTime.now();
  DateTime _stop = DateTime.now();
  DateTime? _notification;
  final TextEditingController _description = TextEditingController();
  final TextEditingController _tag = TextEditingController();
  bool _notify = false;
  List<UIFile> _files = [];
  List<UIFile>? _oldFiles;

  Future<void> _submit() async {
    int? eventId;
    if (widget.edit != null) {
      var event = UpdateEvent(
        start: _start.toUtc(),
        stop: _stop.toUtc(),
        type: widget.type.id,
        description: _description.text,
        id: widget.edit?.id,
        notificationTime: _notify ? _notification?.toUtc() : null,
        source: widget.edit?.source,
        sourceId: widget.edit?.sourceId,
        tag: _tag.text,
      );
      await Dependencies.services.event.updateEvent(event);
      eventId = widget.edit?.id;
    } else {
      var event = CreateEvent(
        start: _start.toUtc(),
        stop: _stop.toUtc(),
        type: widget.type.id,
        description: _description.text,
        notificationTime: _notify ? _notification?.toUtc() : null,
        source: ImportTypes.none,
        sourceId: '',
        tag: _tag.text,
      );
      eventId = await Dependencies.services.event.addEvent(
        event,
        person: widget.person,
      );
    }

    if (eventId != null) {
      // find the files to add
      List<UIFile> fileToAdd = [];
      List<UIFile> fileToDelete = [];
      if (widget.edit == null) {
        fileToAdd = _files;
      } else {
        final newId = _files
            .where((e) => e.id != null)
            .map((e) => e.id)
            .toSet();

        final oldId = _oldFiles?.map((e) => e.id).toSet() ?? {};

        fileToAdd = _files
            .where(
              (e) =>
                  (e.id == null || e.id == 0 && e.file != null) ||
                  !oldId.contains(e.id),
            )
            .toList();

        fileToDelete =
            _oldFiles?.where((e) => !newId.contains(e.id)).toList() ?? [];
      }

      await Dependencies.logics.files.syncFiles(
        fileToAdd,
        fileToDelete.map((e) => e.id ?? 0),
        widget.person,
        (int fileId) => Dependencies.services.files.linkEvent(
          fileId,
          eventId!,
          widget.person,
        ),
        (int fileId) => Dependencies.services.files.unlinkEvent(
          fileId,
          eventId!,
          widget.person,
        ),
        (double progress, String status) => setState(() {
          progress = progress;
          stateInfo = status;
        }),
      );
    }

    widget.callback.call();
  }

  @override
  void initState() {
    super.initState();

    var edit = widget.edit;
    if (edit != null) {
      _start = edit.start;
      _stop = edit.stop;
      _description.text = edit.description ?? '';
      _tag.text = edit.tag ?? '';
      _notify = edit.notificationTime != null;
      _notification = edit.notificationTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return SquareDialog(
      title: Text(locale.addItem(widget.type.name)),
      icon: const Icon(Icons.add_chart_sharp),
      actions: [submitButton(locale.submit, _submit)],
      content: Form(
        child: SingleChildScrollView(
          child: Column(
            spacing: UIConstants.formPad,
            children: [
              SquareTextField(
                icon: Icons.description_sharp,
                label: locale.description,
                controller: _description,
              ),
              SquareTextField(
                icon: Icons.tag_sharp,
                label: locale.tag,
                controller: _tag,
              ),
              DateInput(
                locale.start,
                _start,
                (date) => setState(() {
                  _start = date ?? DateTime.now();
                  _stop = _stop.isBefore(_start) ? _start : _stop;
                }),
              ),
              DateInput(
                locale.end,
                _stop,
                (date) => setState(() {
                  _stop = date ?? DateTime.now();
                  _start = _start.isAfter(_stop) ? _stop : _start;
                }),
              ),
              HelseSwitch(
                "Notify: ",
                _notify,
                (value) => setState(() {
                  _notify = value;
                }),
              ),
              if (_notify)
                DateInput(
                  locale.notificationTime,
                  _notification,
                  (date) => setState(() {
                    _notification = date;
                  }),
                ),
              EventFileList(
                event: widget.edit?.id,
                person: widget.person,
                onChange: (x) {
                  _oldFiles ??= x.toList();
                  _files = x;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
