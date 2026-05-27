import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/care/patient_add.dart';
import 'package:helse/ui/blocs/care/share_patient_dialog.dart';
import 'package:helse/ui/blocs/imports/file_import.dart';

class PatientMenu extends StatefulWidget {
  final Person person;
  final void Function() callback;
  const PatientMenu(this.person, this.callback, {super.key});

  @override
  State<PatientMenu> createState() => _PatientMenuState();
}

class _PatientMenuState extends State<PatientMenu> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  final MenuController _controller = MenuController();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return MenuAnchor(
      controller: _controller,
      childFocusNode: _buttonFocusNode,
      builder: (context, controller, child) => IconButton(
        focusNode: _buttonFocusNode,
        onPressed: () {
          if (_controller.isOpen) {
            controller.close();
          } else {
            controller.open();
          }
        },
        icon: Icon(Icons.menu),
      ),
      menuChildren: [
        Container(
          margin: EdgeInsets.all(8),
          child: ElevatedButton.icon(
            label: Text("Edit"),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return PatientAdd(widget.callback, edit: widget.person);
                },
              );
            },
            icon: Icon(Icons.edit_sharp, color: theme.primary),
          ),
        ),
        Container(          
          margin: EdgeInsets.all(8),
          child: ElevatedButton.icon(
            label: Text("Share"),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return SharePatientDialog(widget.person);
                },
              );
            },
            icon: Icon(Icons.share_sharp, color: theme.primary),
          ),
        ),
        Container(
          margin: EdgeInsets.all(8),
          child: ElevatedButton.icon(
            label: Text('Import'),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return FileImport(patient: widget.person.id);
                },
              );
            },
            icon: Icon(Icons.upload_file_sharp, color: theme.primary),
          ),
        ),
      ],
    );
  }
}
