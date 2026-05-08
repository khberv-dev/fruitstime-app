import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class OrdersEmptyState extends StatelessWidget {
  final VoidCallback onBrowseClick;

  const OrdersEmptyState({super.key, required this.onBrowseClick});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xfffff3cc),
              borderRadius: BorderRadius.circular(AppRadius.round),
            ),
            child: SvgPicture.asset(
              'assets/icons/package.svg',
              width: 54,
              colorFilter: const ColorFilter.mode(Color(0xffd4a017), BlendMode.srcIn),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          Text(
            localization.ordersEmptyTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall!.copyWith(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            localization.ordersEmptySubtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: scheme.onSurfaceVariant,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onBrowseClick,
              child: Text(localization.ordersEmptyBrowseButton),
            ),
          ),
        ],
      ),
    );
  }
}
