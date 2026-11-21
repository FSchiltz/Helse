import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show compute;
import 'package:material_ui/material_ui.dart';
import 'package:helse/di/app_logger.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/care/patient_menu.dart';
import 'package:helse/ui/blocs/care/patients_dashboard.dart';
import 'package:helse/ui/common/layout/common_card.dart';
import 'package:helse/ui/common/loader.dart';

class PatientsCard extends StatefulWidget {
  final Person person;
  final void Function() callback;
  const PatientsCard(this.person, this.callback, {super.key});

  @override
  State<PatientsCard> createState() => _PatientsCardState();
}

class _PatientsCardState extends State<PatientsCard> {
  Uint8List? _profilePicture;
  bool _isLoadingProfilePicture = true;

  @override
  void initState() {
    super.initState();
    _loadProfilePicture();
  }

  Future<void> _loadProfilePicture() async {
    try {
      final picture = await Dependencies.services.user
          .patientProfilePicture(widget.person.id)
          .timeout(const Duration(seconds: 10));
      if (picture != null) {
        final imageBytes = await compute(base64Decode, picture);
        if (mounted) {
          setState(() => _profilePicture = imageBytes);
        }
      }
    } on TimeoutException catch (error, stackTrace) {
      appLogger.w(
        'Timed out loading patient profile picture',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoadingProfilePicture = false);
      }
    }
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
                              _profilePicture!,
                              fit: BoxFit.cover,
                            )
                          : _isLoadingProfilePicture
                          ? const HelseLoader(size: 32)
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
