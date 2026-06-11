import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/app/presentation/ui/app_screen.dart';
import 'package:fruitstime/features/order/domain/entity/order_entity.dart';
import 'package:fruitstime/features/order/domain/entity/order_item_entity.dart';
import 'package:fruitstime/features/order/presentation/controller/selected_order_provider.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/lib.dart';
import 'package:go_router/go_router.dart';

class OrderDetailScreen extends ConsumerWidget {
  static const path = '/order-detail';

  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final order = ref.watch(selectedOrderProvider);

    void onBackClick() => context.pop();

    void onDoneClick() => context.go(AppScreen.path);

    if (order == null) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: onBackClick,
                      icon: SvgPicture.asset('assets/icons/arrow_left.svg'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    final subtotal = order.subtotal;
    final discount = order.discount;
    final totalPaid = order.grandTotal;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            children: [
              SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  IconButton(
                    onPressed: onBackClick,
                    icon: SvgPicture.asset('assets/icons/arrow_left.svg'),
                  ),
                  Expanded(
                    child: Text(
                      localization.orderConfirmedTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge!.copyWith(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _HeroCard(posId: order.posId),
                      SizedBox(height: AppSpacing.md),
                      _DetailsCard(
                        order: order,
                        subtotal: subtotal,
                        discount: discount,
                        totalPaid: totalPaid,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onDoneClick,
                  style: FilledButton.styleFrom(
                    backgroundColor: scheme.onSurface,
                    foregroundColor: scheme.surface,
                    fixedSize: const Size.fromHeight(48),
                  ),
                  child: Text(localization.doneButton),
                ),
              ),
              SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final int? posId;

  const _HeroCard({required this.posId});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withAlpha(60),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            localization.orderThankYou,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: scheme.onPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 8),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  localization.orderNumberSmallLabel,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: scheme.onSurfaceVariant.withAlpha(160),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '#${posId ?? '—'}',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final OrderEntity order;
  final int subtotal;
  final int discount;
  final int totalPaid;

  const _DetailsCard({
    required this.order,
    required this.subtotal,
    required this.discount,
    required this.totalPaid,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.onSurfaceVariant.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                localization.orderDetailsTitle,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontSize: 15, fontWeight: FontWeight.w900),
              ),
              const Spacer(),
              Text(
                order.createdAt.format(pattern: 'MMM d, HH:mm'),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: scheme.onSurfaceVariant.withAlpha(180),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          for (final item in order.items) ...[
            _ItemRow(item: item),
            SizedBox(height: AppSpacing.sm),
          ],
          Divider(height: 1, color: scheme.onSurfaceVariant.withAlpha(40)),
          SizedBox(height: AppSpacing.sm),
          _SummaryRow(
            label: localization.subtotalLabel,
            value: localization.priceText(formatNumber(subtotal)),
            labelColor: scheme.onSurfaceVariant,
            valueColor: scheme.onSurface,
            valueWeight: FontWeight.w600,
          ),
          if (discount > 0) ...[
            SizedBox(height: AppSpacing.xs),
            _SummaryRow(
              label: localization.loyaltyDiscountLabel,
              value: '−${localization.priceText(formatNumber(discount))}',
              labelColor: scheme.onSurfaceVariant,
              valueColor: scheme.secondary,
              valueWeight: FontWeight.w600,
            ),
          ],
          if (order.deliveryCost != null && order.deliveryCost! > 0) ...[
            SizedBox(height: AppSpacing.xs),
            _SummaryRow(
              label: localization.deliveryFeeLabel,
              value: localization.priceText(formatNumber(order.deliveryCost!)),
              labelColor: scheme.onSurfaceVariant,
              valueColor: scheme.onSurface,
              valueWeight: FontWeight.w600,
            ),
          ],
          SizedBox(height: AppSpacing.sm),
          _SummaryRow(
            label: localization.totalPaidLabel,
            value: localization.priceText(formatNumber(totalPaid)),
            labelColor: scheme.onSurface,
            valueColor: scheme.primary,
            labelSize: 15,
            labelWeight: FontWeight.w900,
            valueSize: 18,
            valueWeight: FontWeight.w900,
          ),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final OrderItemEntity item;

  const _ItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final lineTotal = item.actualPrice;

    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xfffff3cc),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text(
            '${item.quantity}',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: const Color(0xffd4a017),
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            item.product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Text(
          localization.priceText(formatNumber(lineTotal)),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final double labelSize;
  final FontWeight labelWeight;
  final double valueSize;
  final FontWeight valueWeight;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
    this.labelSize = 13,
    this.labelWeight = FontWeight.w500,
    this.valueSize = 13,
    this.valueWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: labelColor,
            fontSize: labelSize,
            fontWeight: labelWeight,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: valueColor,
            fontSize: valueSize,
            fontWeight: valueWeight,
          ),
        ),
      ],
    );
  }
}
