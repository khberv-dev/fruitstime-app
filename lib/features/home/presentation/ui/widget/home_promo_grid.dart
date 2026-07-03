import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/home/presentation/ui/widget/home_promo_card.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class HomePromoGrid extends StatelessWidget {
  final VoidCallback onCardTap;

  const HomePromoGrid({super.key, required this.onCardTap});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return SizedBox(
      height: 220,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: HomePromoCard(
                    title: localization.homePromoSmoothieTitle,
                    imagePath: 'assets/images/smoothie.svg',
                    backgroundColor: const Color(0xfff5bd1f),
                    foregroundColor: Colors.white,
                    onTap: onCardTap,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Expanded(
                  child: HomePromoCard(
                    title: localization.homePromoVitaminTitle,
                    imagePath: 'assets/images/vitamin.svg',
                    backgroundColor: const Color(0xff7b3fa0),
                    foregroundColor: Colors.white,
                    onTap: onCardTap,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: HomePromoCard(
              title: localization.homePromoDeliveryTitle,
              imagePath: 'assets/images/delivery.svg',
              backgroundColor: const Color(0xff5a8a3c),
              foregroundColor: Colors.white,
              textAlignment: Alignment.topLeft,
              onTap: onCardTap,
            ),
          ),
        ],
      ),
    );
  }
}
