import 'package:flutter/material.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class PromptDialog extends StatelessWidget {
  final String title;
  final String content;

  const PromptDialog({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    void onYesClick() {
      context.pop(true);
    }

    void onNoClick() {
      context.pop(false);
    }

    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(onPressed: onYesClick, child: Text(localization.promptYes)),
        TextButton(onPressed: onNoClick, child: Text(localization.promptNo)),
      ],
    );
  }
}
