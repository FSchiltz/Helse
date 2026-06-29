import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/logic/fit/fit_constants.dart';
import 'package:helse/logic/fit/fit_helper.dart';
import 'package:helse/logic/settings/health_settings.dart';
import 'package:helse/ui/common/inputs/custom_switch.dart';
import 'package:helse/ui/common/inputs/statefull_check.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:helse/ui/common/square_button.dart';
import 'package:helse/ui/common/ui_constants.dart';

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
  String? _status;
  Map<String, HealthRecordSettings> _records = {};

  @override
  void initState() {
    super.initState();

    _isSupported = FitHelper.isSupported();
  }

  Future<int> _getData(bool refresh) async {
    var health = Dependencies.logics.settings.getHealth();
    _healthEnabled = health.syncHealth;
    _lastRun = Dependencies.logics.settings.getLastRun();
    _background = health.background;
    _history = health.history;
    _status = Dependencies.logics.settings.getLastStatus();

    _records = FitConstants.types.groupFoldBy(
      (e) => e.name,
      (v, e) => HealthRecordSettings(health.records[e.name]?.sync ?? false),
    );
    return 1;
  }

  Future<void> _submitHealth() async {
    final locale = Translation.of(context);

    try {
      // save the user's settings
      await Dependencies.logics.settings.saveHealth(
        HealthSettings(_healthEnabled, _history, _background, _records),
      );

      Notify.show(locale.saved, context: (mounted) ? context : null);
      if (_healthEnabled) {
        await Dependencies.logics.health.requestPermissions();
      }

      if (_history) {
        await Dependencies.logics.health.requestHistoryPermissions();
      }

      if (_background) {
        await Dependencies.logics.health.requestBackgroundPermission();
      }
    } catch (ex) {
      if (mounted) {
        Notify.show(
          locale.error(ex.toString()),
          context: context,
          kind: NotificationKind.error,
        );
      }
    }
  }

  void _resetLastRun() async {
    Dependencies.logics.settings.removeLastRun();
    setState(() {
      _lastRun = null;
      _status = null;
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
              const SizedBox(height: UIConstants.formPad),
              HelseSwitch(locale.enable, _healthEnabled, (bool? value) async {
                setState(() {
                  _healthEnabled = value == true;
                });

                await _submitHealth();
                reset();
              }),
              ..._getForm(locale, reset),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _getForm(AppLocalizations locale, void Function() reset) {
    if (!_healthEnabled) return [];
    return [
      const SizedBox(height: UIConstants.formPad),
      HelseSwitch(locale.syncHistoryToggle, _history, (bool? value) async {
        setState(() {
          _history = value == true;
        });

        await _submitHealth();
        reset();
      }),
      const SizedBox(height: UIConstants.formPad),
      HelseSwitch(locale.syncBackgroundToggle, _background, (
        bool? value,
      ) async {
        setState(() {
          _background = value == true;
        });

        await _submitHealth();
        reset();
      }),
      const SizedBox(height: UIConstants.formPad),
      Text(
        locale.lastRun(_lastRun ?? ''),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: UIConstants.formPad),
      Text(
        locale.lastStatus(_status ?? ''),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: UIConstants.formPad),
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 320),
        child: SquareButton(locale.resetLastRun, _resetLastRun),
      ),
      const SizedBox(height: UIConstants.headerPad),
      SizedBox(
        width: 200,
        child: SquareButton(locale.save, () async {
          await _submitHealth();
          reset();
        }),
      ),
      const SizedBox(height: UIConstants.formPad),
      Flexible(
        child: SingleChildScrollView(
          child: DataTable(
            columns: [
              DataColumn(label: Expanded(child: Text(locale.name))),
              DataColumn(label: Expanded(child: Text(locale.enable))),
            ],
            rows: _records.entries
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(e.key)),
                      DataCell(
                        StatefullCheck(e.value.sync, (v) => e.value.sync = v),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    ];
  }
}
