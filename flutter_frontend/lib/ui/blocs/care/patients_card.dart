import 'dart:convert';
import 'package:material_ui/material_ui.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/care/patient_menu.dart';
import 'package:helse/ui/blocs/care/patients_dashboard.dart';
import 'package:helse/ui/common/layout/common_card.dart';

class PatientsCard extends StatefulWidget {
  final Person person;
  final void Function() callback;
  const PatientsCard(this.person, this.callback, {super.key});

  @override
  State<PatientsCard> createState() => _PatientsCardState();
}

class _PatientsCardState extends State<PatientsCard> {
  String? _profilePicture;

  @override
  void initState() {
    super.initState();
    Dependencies.services.user
        .patientProfilePicture(widget.person.id)
        .then((picture) {
      if (mounted) {
        setState(() => _profilePicture = picture);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return CommonCard(
      padding: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => PatientsDashboard(widget.person, 0),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: theme.onPrimary, width: 1),
                    ),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: _profilePicture != null
                          ? Image.memory(
                              base64Decode(_profilePicture!),
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.person_sharp,
                              size: 40,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                    ),
                  ),
                  Text(
                    widget.person.name ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    widget.person.surname ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          PatientMenu(widget.person, widget.callback),
        ],
      ),
    );
  }
}
