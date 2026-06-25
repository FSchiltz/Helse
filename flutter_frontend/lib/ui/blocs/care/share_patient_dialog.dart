import 'package:flutter/material.dart';
import 'package:helse/ui/common/popup_submit_state.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/inputs/custom_switch.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../di/dependencies.dart';
import '../../common/layout/square_dialog.dart';
import '../../common/inputs/values_input.dart';

class SharePatientDialog extends StatefulWidget {
  final Person patient;

  const SharePatientDialog(this.patient, {super.key});

  @override
  State<SharePatientDialog> createState() => _SharePatientDialogState();
}

class _SharePatientDialogState extends PopupSubmitState<SharePatientDialog> {
  int caregiver = 0;
  bool edit = false;

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
      actions: [submitButton(locale.share, (caregiver > 0) ? _submit : null)],
      content: LoadingBuilder(
        _getCaregiver,
        builder: (context, data, reset) {
          return Column(children: [..._shareForm(data, widget.patient)]);
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

  Future<void> _submit() async {
    // save the user
    var patient = widget.patient.id;

    await Dependencies.services.user.sharePatient(
      patient: patient,
      caregiver: caregiver,
      edit: edit,
    );
  }
}
