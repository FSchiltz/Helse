import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/logic/fit/fit_logic.dart';
import 'package:helse/logic/settings/health_settings.dart';
import 'package:helse/ui/common/custom_switch.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';

class SyncSettings extends StatefulWidget {
  const SyncSettings({super.key});

  @override
  State<SyncSettings> createState() => _SyncSettingsState();
}

class _SyncSettingsState extends State<SyncSettings> {
  bool _isSupported = false;
  String? _lastRun;
  bool _healthEnabled = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _isSupported = FitLogic.isSupported();
  }

  Future<int> _getData(bool refresh) async {
    _healthEnabled = (await Dependencies.logics.settings.getHealth()).syncHealth;
    _lastRun = (await Dependencies.logics.settings.getLastRun());

    return 1;
  }

  Future<void> _submitHealth() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        // save the user's settings
        await Dependencies.logics.settings.saveHealth(HealthSettings(_healthEnabled));

        Notify.show("Saved Successfully");
      }
    } catch (ex) {
      Notify.showError("Error: $ex");
    }
  }

  Future<void> _resetLastRun() async {
    await Dependencies.logics.settings.removeLastRun();
    setState(() {
      _lastRun = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSupported) {
      return Center(child: Text("Not supported"));
    }

    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sync from Google Health",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      const Text("Enable"),
                      CustomSwitch(
                        value: _healthEnabled,
                        onChanged: (bool? value) {
                          setState(() async {
                            _healthEnabled = value!;
                            await _submitHealth();
                            reset();

                            // Stop or start
                            if (value) {
                              Dependencies.blocs.fit.start();
                            } else {
                              Dependencies.blocs.fit.cancel();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Last run: $_lastRun",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                      shape: const ContinuousRectangleBorder(),
                    ),
                    onPressed: _resetLastRun,
                    child: const Text("Rest last run"),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
