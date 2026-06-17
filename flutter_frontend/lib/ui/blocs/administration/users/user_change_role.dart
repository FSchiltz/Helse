import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/administration/users/userright_input.dart';
import 'package:helse/ui/common/square_button.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';

import '../../../common/notification.dart';

class ChangeRole extends StatefulWidget {
  final void Function() callback;
  final List<UserType> types;
  final int id;

  const ChangeRole(this.callback, this.types, this.id, {super.key});

  @override
  State<ChangeRole> createState() => _ChangeRoleState();
}

class _ChangeRoleState extends State<ChangeRole> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  List<UserType> types = [];

  @override
  void initState() {
    super.initState();

    types = widget.types;
  }

  _ChangeRoleState();

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return SquareDialog(
      title: const Text("Change role"),
      actions: [SquareButton(locale.update, () => submit(locale))],
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              UserRightInput(
                value: types,
                UserType.values.where((e) => e.index > 0).toList(),
                (value) => setState(() {
                  types = value;
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submit(AppLocalizations locale) async {
    var localContext = context;
    try {
      // save the user
      await Dependencies.services.user.updatePerson(
        UpdatePerson(
          id: widget.id,
          types: types
              .where((x) => x != UserType.swaggerGeneratedUnknown)
              .toList(),
        ),
      );

      widget.callback.call();

      if (localContext.mounted) {
        Navigator.of(localContext).pop();
      }

      Notify.show(locale.saved);
    } catch (ex) {
      Notify.showError(locale.error(ex.toString()));
    }
  }
}
