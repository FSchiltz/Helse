import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/ui/common/square_button.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../../common/notification.dart';
import 'event_form.dart';

class EventTypeAdd extends StatefulWidget {
  final void Function()? callback;
  final EventType? edit;

  const EventTypeAdd(this.callback, {super.key, this.edit});

  @override
  State<EventTypeAdd> createState() => _EventTypeAddState();
}

class _EventTypeAddState extends State<EventTypeAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    var edit = widget.edit;
    if (edit != null) {
      // this is not a new addition, just an edit
      controllerDescription.text = edit.description ?? "";
      controllerName.text = edit.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return SquareDialog(
      title: const Text("Add a new Event type"),
      actions: [
        SquareButton(
          widget.edit == null ? locale.create : locale.update,
          () => submit(locale),
        ),
      ],
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              EventAddForm(
                controllerDescription: controllerDescription,
                controllerName: controllerName,
                visible: _visible,
                visibleCallback: (bool value) => setState(() {
                  _visible = value;
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submit(AppLocalizations locale) async {
    var localContext = context;
    try {
      if (_formKey.currentState?.validate() ?? false) {
        var event = EventType(
          description: controllerDescription.text,
          name: controllerName.text,
          standAlone: true,
          id: widget.edit?.id ?? 0,
          visible: _visible,
          userEditable: true,
        );

        if (widget.edit == null) {
          await Dependencies.services.event.addEventsType(event);
        } else {
          await Dependencies.services.event.updateEventsType(event);
        }

        _formKey.currentState?.reset();
        widget.callback?.call();

        if (localContext.mounted) {
          Navigator.of(localContext).pop();
        }

        Notify.show(locale.saved);
      }
    } catch (ex) {
      Notify.showError(locale.error(ex.toString()));
    }
  }

  @override
  void dispose() {
    controllerDescription.dispose();
    controllerName.dispose();
    super.dispose();
  }
}
