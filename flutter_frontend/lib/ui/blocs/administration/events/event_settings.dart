import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
import 'package:helse/ui/common/notification.dart';

import '../../../common/loader.dart';

class EventSettingsView extends StatefulWidget {
  const EventSettingsView({super.key});

  @override
  State<EventSettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<EventSettingsView> {
  Proxy? _settings;
  final GlobalKey<FormState> _formKey = GlobalKey();

  void _resetSettings() {
    setState(() {
      _settings = null;
      _dummy = !_dummy;
    });
  }

  bool _dummy = false;

  Future<Proxy?> _getData(bool reset) async {
    // if the users has not changed, no call to the backend
    if (_settings != null) return _settings;

    _settings = const Proxy();
    return _settings;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getData(_dummy),
        builder: (context, snapshot) {
          // Checking if future is resolved
          if (snapshot.connectionState == ConnectionState.done) {
            // If we got an error
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: const TextStyle(fontSize: 18),
                ),
              );

              // if we got our data
            } else if (snapshot.hasData) {
              return Form(
                key: _formKey,
                child: const Column(
                  children: [
                    /*ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: const ContinuousRectangleBorder(),
                      ),
                      onPressed: submit,
                      child: const Text("Save"),
                    ),*/
                  ],
                ),
              );
            }
          }
          return const Center(
              child: SizedBox(width: 50, height: 50, child: HelseLoader()));
        });
  }

  void submit() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        // save the settings
        // await AppState.settings?.save();

        Notify.show("Saved Successfully");

        _resetSettings();
      }
    } catch (ex) {
      Notify.show("Error: $ex");
    }
  }
}
