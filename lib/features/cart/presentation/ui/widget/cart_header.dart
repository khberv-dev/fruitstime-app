import 'package:flutter/material.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class CartHeader extends StatelessWidget {
  const CartHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return SizedBox(
      height: 56,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.cartTitle,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
