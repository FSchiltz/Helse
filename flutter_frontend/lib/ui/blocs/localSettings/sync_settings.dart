import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
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
  bool _background = false;
  bool _history = false;

  @override
  void initState() {
    super.initState();

    _isSupported = Dependencies.logics.fit.isSupported();
  }

  Future<int> _getData(bool refresh) async {
    var health = await Dependencies.logics.settings.getHealth();
    _healthEnabled = health.syncHealth;
    _lastRun = Dependencies.logics.settings.getLastRun();
    _background = health.background;
    _history = health.history;
    return 1;
  }

  Future<void> _submitHealth() async {
    try {
      // save the user's settings
      Dependencies.logics.settings.saveHealth(
        HealthSettings(_healthEnabled, _history, _background),
      );

      Notify.show("Saved Successfully");
      if (_healthEnabled) {
        await Dependencies.logics.fit.requestPermissions();
      }

      if (_history) {
        await Dependencies.logics.fit.requestHistoryPermissions();
      }

      if (_background) {
        await Dependencies.logics.fit.requestBackgroundPermission();
      }
    } catch (ex) {
      Notify.showError("Error: $ex");
    }
  }

  void _resetLastRun() async {
    Dependencies.logics.settings.removeLastRun();
    setState(() {
      _lastRun = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSupported) {
      return Center(child: Text("Not supported"));
    }

    var locale = Translation.of(context);
    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                locale.syncFit,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Text(locale.enable),
                    CustomSwitch(
                      value: _healthEnabled,
                      onChanged: (bool? value) async {
                        setState(() {
                          _healthEnabled = value == true;
                        });

                        await _submitHealth();
                        reset();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Text(locale.syncHistoryToggle),
                    CustomSwitch(
                      value: _history,
                      onChanged: (bool? value) async {
                        setState(() {
                          _history = value == true;
                        });

                        await _submitHealth();
                        reset();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Text(locale.syncBackgroundToggle),
                    CustomSwitch(
                      value: _background,
                      onChanged: (bool? value) async {
                        setState(() {
                          _background = value == true;
                        });

                        await _submitHealth();
                        reset();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                locale.lastRun(_lastRun ?? ''),
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
                  child: Text(locale.resetLastRun),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
