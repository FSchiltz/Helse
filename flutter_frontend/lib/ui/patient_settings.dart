import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/localSettings/metric_settings.dart';

class PatientSettingsPage extends StatelessWidget {
  final int? person;
  final List<Person>? patients;
  const PatientSettingsPage(this.person, {super.key, this.patients});

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    var theme = Theme.of(context).textTheme;
    var settings = Dependencies.logics.patientsSettings.patientsSettings();
    return Scaffold(
      appBar: AppBar(title: Text(locale.patientsSettings)),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (person == null)
              Text(
                "Default settings for the patients. Patients ${settings.patients?.map((e) => patients?.firstWhereOrNull((x) => x.id == e.patientId)?.name).join(',')} are overrided",
                style: theme.headlineSmall,
              ),
            Expanded(child: MetricsSettings(isPatient: true, patient: person)),
          ],
        ),
      ),
    );
  }
}
