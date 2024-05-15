import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/ui/common/square_dialog.dart';

import '../../../../services/swagger/generated_code/swagger.swagger.dart';
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
  Widget build(BuildContext context) {
    var edit = widget.edit;
    if (edit != null) {
      // this is not a new addition, just an edit
      controllerDescription.text = edit.description ?? "";
      controllerName.text = edit.name ?? "";
    }

    return SquareDialog(
      title: const Text("Add a new Event type"),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: const ContinuousRectangleBorder(),
          ),
          onPressed: submit,
          child: Text(widget.edit == null ? "Create" : "Update"),
        ),
      ],
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
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

  void submit() async {
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
        String text;

        if (widget.edit == null) {
          text = "Added";
          await DI.event?.addEventsType(event);
        } else {
          text = "Updated";
          await DI.event?.updateEventsType(event);
        }

        _formKey.currentState?.reset();
        widget.callback?.call();

        if (localContext.mounted) {
          Navigator.of(localContext).pop();
        }

        Notify.show("$text Successfully");
      }
    } catch (ex) {
      Notify.showError("Error: $ex");
    }
  }

  @override
  void dispose() {
    controllerDescription.dispose();
    controllerName.dispose();
    super.dispose();
  }
}
