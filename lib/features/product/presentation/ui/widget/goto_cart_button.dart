import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class GotoCartButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GotoCartButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        fixedSize: Size(148, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.round)),
      ),
      child: Text(localization.goToCartButton),
    );
  }
}
