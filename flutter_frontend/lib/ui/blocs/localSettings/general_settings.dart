import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/services/swagger/generated_code/helseapi.enums.swagger.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:helse/ui/common/square_outline_input_border.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({super.key});

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  InterfaceTheme _theme = InterfaceTheme.system;
  DatePreset _range = DatePreset.today;

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
    _theme = await Dependencies.logics.settings.getTheme();
    _range = await Dependencies.logics.settings.getDateRange();

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
    var theme = Theme.of(context).colorScheme;
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
                    prefixIconColor: theme.primary,
                    filled: true,
                    fillColor: theme.surface,
                    border: SquareOutlineInputBorder(theme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Default range for the date. This may be overidden by the last used range",
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
                      prefixIconColor: theme.primary,
                      filled: true,
                      fillColor: theme.surface,
                      border: SquareOutlineInputBorder(theme.primary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
