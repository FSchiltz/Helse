import 'package:flutter/material.dart';

class ErrorSnackBar extends SnackBar {
  static show(String content, BuildContext localContext) {
    if (localContext.mounted) {
      ScaffoldMessenger.of(localContext).showSnackBar(
        ErrorSnackBar(content, localContext),
      );
    }
  }

  ErrorSnackBar(String content, BuildContext localContext, {super.key})
      : super(
            width: 200,
            backgroundColor: Theme.of(localContext).colorScheme.errorContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            behavior: SnackBarBehavior.floating,
            content: Text(content));
}

class SuccessSnackBar extends SnackBar {
  static show(String content, BuildContext localContext) {
    if (localContext.mounted) {
      ScaffoldMessenger.of(localContext).showSnackBar(
        SuccessSnackBar(content, localContext),
      );
    }
  }

  SuccessSnackBar(String content, BuildContext localContext, {super.key})
      : super(
            width: 200,
            backgroundColor: Theme.of(localContext).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            behavior: SnackBarBehavior.floating,
            content: Text(content));
}
