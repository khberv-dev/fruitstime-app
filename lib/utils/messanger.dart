import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, String message) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  scaffoldMessenger.clearSnackBars();
  scaffoldMessenger.showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Theme.of(context).colorScheme.error),
  );
}

void showInfoMessage(BuildContext context, String message) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  scaffoldMessenger.clearSnackBars();
  scaffoldMessenger.showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Theme.of(context).colorScheme.secondary),
  );
}
