import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/order/data/enum/order_status.dart';
import 'package:fruitstime/features/order/domain/entity/order_entity.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/lib.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onTap;
  final bool glow;

  const OrderCard({super.key, required this.order, this.onTap, this.glow = false});

  String _statusLabel(AppLocalizations l) => switch (order.status) {
    OrderStatus.created => l.orderStatusCreated,
    OrderStatus.done => l.orderStatusDone,
    OrderStatus.cancelled => l.orderStatusCanceled,
  };

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    final (statusBg, statusFg, dotColor) = switch (order.status) {
      OrderStatus.done => (scheme.secondary.withAlpha(30), scheme.secondary, scheme.secondary),
      OrderStatus.cancelled => (scheme.error.withAlpha(30), scheme.error, scheme.error),
      OrderStatus.created => (
        scheme.onSurfaceVariant.withAlpha(30),
        scheme.onSurfaceVariant,
        scheme.onSurfaceVariant,
      ),
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: glow ? scheme.primary.withAlpha(120) : scheme.onSurfaceVariant.withAlpha(40),
          ),
          boxShadow: glow
              ? [BoxShadow(color: scheme.primary.withAlpha(60), blurRadius: 20, spreadRadius: 2)]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: Row(
                children: [
                  Text(
                    '#${order.posId ?? '—'}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(fontSize: 15, fontWeight: FontWeight.w900),
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
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.itemsSummary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    localization.orderItemsCount(order.itemsCount),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: scheme.onSurfaceVariant.withAlpha(40)),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    localization.priceText(formatNumber(order.grandTotal)),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: order.discount > 0 ? scheme.secondary : null,
                    ),
                  ),
                  if (order.discount > 0) ...[
                    const SizedBox(width: 8),
                    Text(
                      localization.priceText(
                        formatNumber(order.subtotal + (order.deliveryCost ?? 0)),
                      ),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: scheme.onSurfaceVariant.withAlpha(140),
                        decoration: TextDecoration.lineThrough,
                        decorationColor: scheme.onSurfaceVariant.withAlpha(140),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
