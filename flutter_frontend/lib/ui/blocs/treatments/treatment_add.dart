import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/square_button.dart';
import 'package:helse/ui/common/inputs/values_input.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../di/dependencies.dart';
import '../../../logic/event.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../common/inputs/date_input.dart';
import '../../common/loader.dart';
import '../../common/notification.dart';
import '../../common/layout/square_dialog.dart';
import '../../common/inputs/square_text_field.dart';

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

      Notify.show(locale.added);
      if (localContext.mounted) {
        Navigator.of(localContext).pop();
      }
    } catch (ex) {
      setState(() {
        _status = SubmissionStatus.failure;
      });
      Notify.showError(locale.error(ex.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return SquareDialog(
      title: Text(locale.addItem(locale.treatment)),
      actions: [
        SizedBox(
          child: _status == SubmissionStatus.inProgress
              ? const HelseLoader()
              : SquareButton(locale.submit, () => _submit(locale)),
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
                const SizedBox(height: UIConstants.formPad),
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
                const SizedBox(height: UIConstants.formPad),
                SquareTextField(
                  icon: Icons.description_sharp,
                  label: "Description",
                  controller: _description,
                ),
                const SizedBox(height: UIConstants.formPad),
                DateInput(
                  "start",
                  _start,
                  (date) => setState(() {
                    _start = date ?? DateTime.now();
                  }),
                ),
                const SizedBox(height: UIConstants.formPad),
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
    return ValuesInput(
      types.map((type) => DropdownItem(type.id, type.name)).toList(),
      callback,
      label: 'Type',
    );
  }
}
