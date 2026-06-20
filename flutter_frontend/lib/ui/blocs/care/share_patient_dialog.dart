import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/inputs/custom_switch.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/square_button.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../di/dependencies.dart';
import '../../../logic/event.dart';
import '../../common/loader.dart';
import '../../common/notification.dart';
import '../../common/layout/square_dialog.dart';
import '../../common/inputs/values_input.dart';

class SharePatientDialog extends StatefulWidget {
  final Person patient;

  const SharePatientDialog(this.patient, {super.key});

  @override
  State<SharePatientDialog> createState() => _SharePatientDialogState();
}

class _SharePatientDialogState extends State<SharePatientDialog> {
  int caregiver = 0;
  bool edit = false;
  SubmissionStatus _status = SubmissionStatus.initial;

  Future<List<Person>> _getCaregiver(bool refresh) {
    return Dependencies.services.user.caregiver();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return SquareDialog(
      title: Text(
        "${locale.share} ${widget.patient.name} ${widget.patient.surname}",
      ),
      content: LoadingBuilder(
        _getCaregiver,
        builder: (context, data, reset) {
          return Column(
            children: [
              ..._shareForm(data, widget.patient),
              _status == SubmissionStatus.inProgress
                  ? const HelseLoader()
                  : SquareButton(
                      locale.share,
                      (caregiver > 0) ? () => _submit(locale) : null,
                    ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _shareForm(List<Person> caregivers, Person patient) {
    var selects = [DropdownItem(0, "Select")];

    selects.addAll(caregivers.map((x) => DropdownItem(x.id, x.userName ?? '')));

    return [
      ValuesInput(
        label: 'Caregiver',
        selects,
        (value) => setState(() {
          caregiver = value ?? 0;
        }),
        value: caregiver,
      ),
      const SizedBox(height: UIConstants.formPad),
      HelseSwitch(
        "With edit right: ",
        edit,
        (value) => setState(() {
          edit = value;
        }),
      ),
    ];
  }

  void _submit(AppLocalizations locale) async {
    var localContext = context;
    try {
      setState(() {
        _status = SubmissionStatus.inProgress;
      });

      try {
        // save the user
        var patient = widget.patient.id;

        await Dependencies.services.user.sharePatient(
          patient: patient,
          caregiver: caregiver,
          edit: edit,
        );

        Notify.show(locale.saved);
        setState(() {
          _status = SubmissionStatus.success;
        });
        if (localContext.mounted) {
          Navigator.of(localContext).pop();
        }
      } catch (_) {
        setState(() {
          _status = SubmissionStatus.failure;
        });
      }
    } catch (ex) {
      Notify.showError(locale.error(ex.toString()));
    }
  }
}
