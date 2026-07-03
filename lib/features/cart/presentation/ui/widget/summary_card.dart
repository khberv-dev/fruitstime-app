import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/cart/presentation/controller/order_evaluation_provider.dart';
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
    final evaluationAsync = ref.watch(orderEvaluationProvider);
    final evaluation = evaluationAsync.value;
    final isLoading = evaluationAsync.isLoading;

    final subtotal = evaluation?.subtotal ?? totalCartPrice;
    final deliveryCost = evaluation?.deliveryCost;
    final total = evaluation?.total ?? totalCartPrice;

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
          SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SummaryKeyText(text: localization.subtotalLabel),
              _SummaryValueText(text: localization.priceText(formatNumber(subtotal))),
            ],
          ),
          for (final discount in evaluation?.discounts ?? []) ...[
            SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SummaryKeyText(text: discount.name),
                Text(
                  '−${localization.priceText(formatNumber(discount.amount))}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: scheme.secondary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
          if (deliveryCost != null || isLoading) ...[
            SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SummaryKeyText(text: localization.deliveryFeeLabel),
                isLoading
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
              isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: scheme.secondary),
                    )
                  : Text(
                      localization.priceText(formatNumber(total)),
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
