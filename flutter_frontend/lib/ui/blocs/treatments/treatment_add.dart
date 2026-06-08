import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/ui/common/loading_builder.dart';

import '../../../di/dependencies.dart';
import '../../../logic/event.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../common/date_input.dart';
import '../../common/loader.dart';
import '../../common/notification.dart';
import '../../common/square_dialog.dart';
import '../../common/square_text_field.dart';

class TreatmentAdd extends StatefulWidget {
  final int? person;

  const TreatmentAdd({super.key, this.person});

  @override
  State<TreatmentAdd> createState() => _TreatementState();
}

class _TreatementState extends State<TreatmentAdd> {
  SubmissionStatus _status = SubmissionStatus.initial;
  DateTime _start = DateTime.now();
  DateTime _stop = DateTime.now();
  final TextEditingController _description = TextEditingController();
  int? _type;

  Future<List<EventType>> _getTypes(bool refresh) async {
    return await Dependencies.services.treatement.treatmentTypes() ?? [];
  }

  void _submit(AppLocalizations locale) async {
    var localContext = context;

    setState(() {
      _status = SubmissionStatus.inProgress;
    });
    try {
      var event = CreateEvent(
        start: _start,
        stop: _stop,
        type: _type ?? 0,
        description: _description.text,
      );
      var treatment = CreateTreatment(events: [event], personId: widget.person);
      await Dependencies.services.treatement.addTreatment(treatment);

      setState(() {
        _status = SubmissionStatus.success;
      });

      if (localContext.mounted) {
        Navigator.of(localContext).pop();
      }
      Notify.show(locale.added);
    } catch (ex) {
      setState(() {
        _status = SubmissionStatus.failure;
      });
      Notify.showError(locale.error(ex.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    var locale = Translation.of(context);
    return SquareDialog(
      title:  Text(locale.addItem(locale.treatment)),
      actions: [
        SizedBox(
          child: _status == SubmissionStatus.inProgress
              ? const HelseLoader()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: const ContinuousRectangleBorder(),
                  ),
                  onPressed: () => _submit(locale),
                  child: Text(locale.submit),
                ),
        ),
      ],
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Manually add a new event",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                LoadingBuilder(
                  _getTypes,
                  builder: (ctx, data, reset) {
                    return _TypeInput(
                      data,
                      (type) => setState(() {
                        _type = type;
                      }),
                    );
                  },
                ),
                const SizedBox(height: 10),
                SquareTextField(
                  theme: theme,
                  icon: Icons.description_sharp,
                  label: "Description",
                  controller: _description,
                ),
                const SizedBox(height: 10),
                DateInput(
                  "start",
                  _start,
                  (date) => setState(() {
                    _start = date ?? DateTime.now();
                  }),
                ),
                const SizedBox(height: 10),
                DateInput(
                  "end",
                  _stop,
                  (date) => setState(() {
                    _stop = date ?? DateTime.now();
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeInput extends StatelessWidget {
  final List<EventType> types;
  final void Function(int?) callback;

  const _TypeInput(this.types, this.callback);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return DropdownButtonFormField(
      onChanged: callback,
      items: types
          .map(
            (type) => DropdownMenuItem(value: type.id, child: Text(type.name)),
          )
          .toList(),
      decoration: InputDecoration(
        labelText: 'Type',
        prefixIcon: const Icon(Icons.list_sharp),
        prefixIconColor: theme.primary,
        filled: true,
        fillColor: theme.surface,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primary),
        ),
      ),
    );
  }
}
