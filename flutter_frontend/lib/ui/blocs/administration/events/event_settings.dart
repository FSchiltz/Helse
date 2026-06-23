import 'package:flutter/material.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';

class EventSettingsView extends StatefulWidget {
  const EventSettingsView({super.key});

  @override
  State<EventSettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<EventSettingsView> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<int> _getData(bool reset) async {
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) {
        return Form(
          key: _formKey,
          child: const Column(children: [
            ],
          ),
        );
      },
    );
  }

  void submit(BuildContext context) async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        // save the settings
        // await AppState.settings?.save();

        Notify.show("Saved Successfully", context);

        //_resetSettings();
      }
    } catch (ex) {
      Notify.show("Error: $ex", context);
    }
  }
}
