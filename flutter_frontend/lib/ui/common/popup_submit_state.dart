import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/logic/event.dart';
import 'package:helse/ui/common/loader.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:helse/ui/common/square_button.dart';

abstract class PopupSubmitState<T extends StatefulWidget> extends State<T> {
  SubmissionStatus status = SubmissionStatus.initial;
  final GlobalKey<FormState> formKey = GlobalKey();

  Widget submitButton(String label, Future<void> Function()? callback) {
    return status == SubmissionStatus.inProgress
        ? const HelseLoader()
        : SquareButton(label, () => submit(callback));
  }

  Future<void> submit(Future<void> Function()? callback) async {
    if (status == SubmissionStatus.inProgress) {
      return;
    }

    final locale = Translation.of(context);
    try {
      setState(() {
        status = SubmissionStatus.inProgress;
      });

      if (formKey.currentState == null ||
          formKey.currentState?.validate() == true) {
        await callback?.call();

        formKey.currentState?.reset();
        if (!mounted) {
          return;
        }

        Notify.showIcon(NotificationKind.success);
        Navigator.of(context).pop();
      } else {
        setState(() {
          status = SubmissionStatus.failure;
        });
      }
    } catch (ex) {
      log(ex.toString());
      setState(() {
        status = SubmissionStatus.failure;
      });
      Notify.show(
        locale.error(ex.toString()),
        context: mounted ? context : null,
        kind: NotificationKind.error,
      );
    }
  }
}
