import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/cart/presentation/controller/delivery_cost_provider.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/lib.dart';

class _SummaryKeyText extends StatelessWidget {
  final String text;

  const _SummaryKeyText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }
}

class _SummaryValueText extends StatelessWidget {
  final String text;

  const _SummaryValueText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w900),
    );
  }
}

class SummaryCard extends ConsumerWidget {
  final int totalItemCount;
  final int totalItemTypeCount;
  final int totalCartPrice;

  const SummaryCard({
    super.key,
    required this.totalItemCount,
    required this.totalItemTypeCount,
    required this.totalCartPrice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final deliveryCostAsync = ref.watch(deliveryCostProvider);
    final deliveryCost = deliveryCostAsync.asData?.value;
    final isLoadingDelivery = deliveryCostAsync.isLoading;

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border.all(color: scheme.onSurfaceVariant.withAlpha(40)),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SummaryKeyText(text: localization.productCountLabel),
              _SummaryValueText(text: totalItemCount.toString()),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SummaryKeyText(text: localization.productTypeLabel),
              _SummaryValueText(text: totalItemTypeCount.toString()),
            ],
          ),
          if (deliveryCost != null || isLoadingDelivery) ...[
            SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SummaryKeyText(text: localization.deliveryFeeLabel),
                isLoadingDelivery
                    ? SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: scheme.onSurfaceVariant,
                        ),
                      )
                    : _SummaryValueText(text: localization.priceText(formatNumber(deliveryCost!))),
              ],
            ),
          ],
          SizedBox(height: AppSpacing.sm),
          Divider(),
          SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localization.totalLabel,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w900),
              ),
              Text(
                localization.priceText(formatNumber(totalCartPrice + (deliveryCost ?? 0))),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: scheme.secondary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
