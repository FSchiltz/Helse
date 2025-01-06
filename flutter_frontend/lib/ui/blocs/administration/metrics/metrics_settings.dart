import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
import 'package:helse/ui/common/notification.dart';

import '../../../common/loader.dart';

class MetricSettingsView extends StatefulWidget {
  const MetricSettingsView({super.key});

  @override
  State<MetricSettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<MetricSettingsView> {
  Proxy? _settings;
  final GlobalKey<FormState> _formKey = GlobalKey();

  void _resetSettings() {
    setState(() {
      _settings = null;
    });
  }

  Future<Proxy?> _getData() async {

    _settings = const Proxy();
    return _settings;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getData(),
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
      Notify.showError("Error: $ex");
    }
  }
}
