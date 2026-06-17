import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/branch/presentation/controller/branches_provider.dart';
import 'package:fruitstime/features/order/data/enum/order_status.dart';
import 'package:fruitstime/features/order/data/enum/order_type.dart';
import 'package:fruitstime/features/order/domain/entity/order_entity.dart';
import 'package:fruitstime/features/order/domain/entity/order_item_entity.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/lib.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailSheet extends ConsumerWidget {
  final OrderEntity order;

  const OrderDetailSheet({super.key, required this.order});

  String _statusLabel(AppLocalizations l) => switch (order.status) {
    OrderStatus.created => l.orderStatusCreated,
    OrderStatus.done => l.orderStatusDone,
    OrderStatus.cancelled => l.orderStatusCanceled,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final localization = AppLocalizations.of(context)!;
    final branchPhone = ref.watch(selectedBranchProvider)?.managerPhone;

    final (statusBg, statusFg, dotColor) = switch (order.status) {
      OrderStatus.done => (scheme.secondary.withAlpha(30), scheme.secondary, scheme.secondary),
      OrderStatus.cancelled => (scheme.error.withAlpha(30), scheme.error, scheme.error),
      OrderStatus.created => (
        scheme.onSurfaceVariant.withAlpha(30),
        scheme.onSurfaceVariant,
        scheme.onSurfaceVariant,
      ),
    };

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.onSurfaceVariant.withAlpha(60),
                  borderRadius: BorderRadius.circular(AppRadius.round),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Text(
                  '#${order.posId ?? '—'}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                SizedBox(width: AppSpacing.sm),
                Text(
                  order.createdAt.format(pattern: 'MMM d, HH:mm'),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: scheme.onSurfaceVariant.withAlpha(180),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(AppRadius.round),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _statusLabel(localization),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: statusFg,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            Container(
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        localization.orderDetailsTitle,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(fontSize: 15, fontWeight: FontWeight.w900),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: order.type == OrderType.delivery
                              ? scheme.primary.withAlpha(20)
                              : scheme.secondary.withAlpha(20),
                          borderRadius: BorderRadius.circular(AppRadius.round),
                        ),
                        child: Text(
                          order.type == OrderType.delivery
                              ? localization.deliveryOption
                              : localization.pickupOption,
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: order.type == OrderType.delivery
                                ? scheme.primary
                                : scheme.secondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
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
                    value: localization.priceText(formatNumber(order.subtotal)),
                    labelColor: scheme.onSurfaceVariant,
                    valueColor: scheme.onSurface,
                    valueWeight: FontWeight.w600,
                  ),
                  if (order.discount > 0) ...[
                    SizedBox(height: AppSpacing.xs),
                    _SummaryRow(
                      label: localization.loyaltyDiscountLabel,
                      value: '−${localization.priceText(formatNumber(order.discount))}',
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
                    value: localization.priceText(formatNumber(order.grandTotal)),
                    labelColor: scheme.onSurface,
                    valueColor: scheme.primary,
                    labelSize: 15,
                    labelWeight: FontWeight.w900,
                    valueSize: 18,
                    valueWeight: FontWeight.w900,
                  ),
                ],
              ),
            ),
            if (order.status == OrderStatus.created) ...[
              SizedBox(height: AppSpacing.md),
              if (branchPhone != null) ...[
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => launchUrl(Uri(scheme: 'tel', path: branchPhone)),
                    child: Text(localization.needHelpButton),
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
              ],
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: scheme.error),
                  onPressed: branchPhone != null
                      ? () => launchUrl(Uri(scheme: 'tel', path: branchPhone))
                      : null,
                  child: Text(localization.cancelButton),
                ),
              ),
            ],
          ],
        ),
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
          localization.priceText(formatNumber(item.actualPrice)),
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
