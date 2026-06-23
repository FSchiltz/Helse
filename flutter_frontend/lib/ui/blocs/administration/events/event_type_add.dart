import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/ui/common/inputs/custom_switch.dart';
import 'package:helse/ui/common/inputs/square_text_field.dart';
import 'package:helse/ui/common/inputs/values_input.dart';
import 'package:helse/ui/common/square_button.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../../common/notification.dart';

class EventTypeAdd extends StatefulWidget {
  final void Function()? callback;
  final EventType? edit;

  const EventTypeAdd(this.callback, {super.key, this.edit});

  @override
  State<EventTypeAdd> createState() => _EventTypeAddState();
}

class _EventTypeAddState extends State<EventTypeAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _name = TextEditingController();
  final _description = TextEditingController();
  final _timeDifference = TextEditingController();
  bool _visible = true;
  int _groupId = 0;

  List<Group> _groups = [];

  @override
  void initState() {
    super.initState();
    var edit = widget.edit;
    if (edit != null) {
      // this is not a new addition, just an edit
      _description.text = edit.description ?? "";
      _name.text = edit.name;
      _timeDifference.text = edit.timeDifference ?? '';
      _groupId = edit.groupId;
    }
    _loadGroup();
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return SquareDialog(
      title: const Text("Add a new Event type"),
      actions: [
        SquareButton(
          widget.edit == null ? locale.create : locale.update,
          () => _submit(locale),
        ),
      ],
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SquareTextField(
                controller: _name,
                label: locale.name,
                icon: Icons.person_sharp,
                validator: _validateName,
              ),
              const SizedBox(height: UIConstants.formPad),
              SquareTextField(
                controller: _description,
                label: locale.description,
                icon: Icons.person_sharp,
              ),
              const SizedBox(height: UIConstants.formPad),
              HelseSwitch(
                locale.visible,
                _visible,
                (bool value) => setState(() {
                  _visible = value;
                }),
              ),
              SizedBox(height: UIConstants.formPad),
              ValuesInput(
                value: _groupId,
                _groups.map((x) => DropdownItem(x.id, x.name)).toList(),
                (value) => setState(() {
                  _groupId = value ?? 0;
                }),
                label: locale.group,
              ),
              const SizedBox(height: UIConstants.formPad),
              Text(locale.timeShiftExplanation),
              SquareTextField(
                label: "Time difference",
                icon: Icons.timeline,
                controller: _timeDifference,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a name.";
    }

    return null;
  }

  Future<void> _loadGroup() async {
    var result = (await Dependencies.services.metric.metricsGroup()) ?? [];
    result.add(Group(name: "Choose", description: '', id: 0));
    setState(() {
      _groups = result;
    });
  }

  void _submit(AppLocalizations locale) async {
    var localContext = context;
    try {
      if (_formKey.currentState?.validate() ?? false) {
        final timeDifference = _timeDifference.text.isEmpty
            ? null
            : _timeDifference.text;

        if (widget.edit == null) {
          final event = CreateEventType(
            description: _description.text,
            name: _name.text,
            standAlone: true,
            visible: _visible,
            timeDifference: timeDifference,
            groupId: _groupId,
          );
          await Dependencies.services.event.addEventsType(event);
        } else {
          final event = UpdateEventType(
            description: _description.text,
            name: _name.text,
            standAlone: true,
            id: widget.edit?.id ?? 0,
            visible: _visible,
            timeDifference: timeDifference,
            groupId: _groupId,
          );
          await Dependencies.services.event.updateEventsType(event);
        }

        _formKey.currentState?.reset();
        widget.callback?.call();

        if (localContext.mounted) {
          Notify.show(locale.saved, localContext);
          Navigator.of(localContext).pop();
        }
      }
    } catch (ex) {
      if (localContext.mounted) {
        Notify.showError(locale.error(ex.toString()), localContext);
      }
      log(ex.toString());
    }
  }

  @override
  void dispose() {
    _description.dispose();
    _name.dispose();
    super.dispose();
  }
}
