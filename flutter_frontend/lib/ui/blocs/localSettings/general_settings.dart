import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.enums.swagger.dart';
import 'package:helse/ui/common/color_selector.dart';
import 'package:helse/ui/common/common_card.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:helse/ui/common/square_outline_input_border.dart';

class ColoredValue {
  final String key;
  final String name;
  Color color;

  ColoredValue(this.key, this.name, {required this.color});
}

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({super.key});

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  InterfaceTheme _theme = InterfaceTheme.system;
  DatePreset _range = DatePreset.today;
  Map<StateType, List<ColoredValue>> _colors = {};

  Future<void> themeCallback(
    InterfaceTheme? value,
    AppLocalizations locale,
  ) async {
    if (value == null) return;
    // save the settings
    _theme = value;
    await _submitTheme(locale);
  }

  Future<void> _submitTheme(AppLocalizations locale) async {
    try {
      // save the user's settings
      await Dependencies.logics.settings.saveTheme(_theme);

      Notify.show(locale.saved);
    } catch (ex) {
      Notify.showError(locale.error(ex.toString()));
    }
  }

  Future<int> _getData(bool reset) async {
    _theme = Dependencies.logics.settings.getTheme();
    _range = Dependencies.logics.settings.getDateRange();

    final metrics = Dependencies.logics.settings.getMetrics();
    final events = Dependencies.logics.settings.getEvents();

    _colors = (Dependencies.logics.settings.getColors()).map(
      (key, value) => MapEntry(
        key,
        value.entries.map((e) {
          String name = e.key;

          final split = e.key.split(';');
          final id = int.tryParse(split[0]);

          switch (key) {
            case StateType.metric:
              name =
                  metrics.displaySettings
                      .firstWhereOrNull((m) => m.id == id)
                      ?.name ??
                  e.key;
            case StateType.events:
              name =
                  events.displaySettings
                      .firstWhereOrNull((m) => m.id == id)
                      ?.name ??
                  e.key;
            case StateType.metricGroup:
              name =
                  metrics.groups?.displaySettings
                      .firstWhereOrNull((m) => m.id == id)
                      ?.name ??
                  e.key;
            default:
          }
          if (split.length > 1) {
            name = '$name-${split[1]}';
          }
          return ColoredValue(e.key, name, color: e.value);
        }).toList(),
      ),
    );

    return 1;
  }

  Future<void> rangeCallback(DatePreset? value) async {
    if (value == null) return;
    try {
      _range = value;
      await Dependencies.logics.settings.setDateRange(value);
      Notify.show("Saved Successfully");
    } catch (ex) {
      Notify.showError("Error: $ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) {
        var locale = Translation.of(context);
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Interface',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 32),
              SizedBox(
                width: 200,
                child: DropdownButtonFormField(
                  initialValue: _theme,
                  onChanged: (value) async {
                    await themeCallback(value, locale);
                    reset();
                  },
                  items: _getThemeValues(),
                  decoration: InputDecoration(
                    labelText: 'Theme',
                    prefixIcon: const Icon(Icons.list_sharp),
                    prefixIconColor: theme.colorScheme.primary,
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    border: SquareOutlineInputBorder(theme.colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Default range for the date when you open the application.",
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  width: 200,
                  child: DropdownButtonFormField(
                    initialValue: _range,
                    onChanged: rangeCallback,
                    items: _getRangeValues(context),
                    decoration: InputDecoration(
                      labelText: 'Date range',
                      prefixIcon: const Icon(Icons.list_sharp),
                      prefixIconColor: theme.colorScheme.primary,
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: SquareOutlineInputBorder(
                        theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    "Colors",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(width: 12),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                        shape: const ContinuousRectangleBorder(),
                      ),
                      onPressed: () async {
                        await _submit(_colors, locale);
                        reset();
                      },
                      child: Text(locale.save),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _colors.entries.map((group) {
                      return CommonCard(
                        padding: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.key.name,
                              style: theme.textTheme.titleMedium,
                            ),
                            DataTable(
                              dataRowMinHeight: 48,
                              dataRowMaxHeight: 60,
                              columns: [
                                DataColumn(
                                  label: Expanded(child: Text(locale.name)),
                                ),
                                DataColumn(
                                  label: Expanded(child: Text(locale.color)),
                                ),
                              ],
                              rows: (group.value)
                                  .map(
                                    (item) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            item.name,
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: ColorSelector(
                                              color: item.color,
                                              context: context,
                                              callback: (v) => item.color = v,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit(
    Map<StateType, List<ColoredValue>> colors,
    AppLocalizations locale,
  ) async {
    try {
      var mapped = colors.map(
        (key, value) => MapEntry(key, {for (var e in value) e.key: e.color}),
      );

      await Dependencies.logics.settings.setColors(mapped);
      Dependencies.theme.loadColors(mapped);

      Notify.show(locale.saved);
    } catch (ex) {
      Notify.showError(locale.error(ex.toString()));
    }
  }

  List<DropdownMenuItem<InterfaceTheme>>? _getThemeValues() {
    return InterfaceTheme.values
        .where((e) => e.index > 0)
        .map((type) => DropdownMenuItem(value: type, child: Text(type.name)))
        .toList();
  }

  List<DropdownMenuItem<DatePreset>>? _getRangeValues(BuildContext context) {
    return DatePreset.values
        .where((e) => e.index > 0)
        .map(
          (type) => DropdownMenuItem(
            value: type,
            child: Text(Translation.get(type, context)),
          ),
        )
        .toList();
  }
}
