import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/order/data/enum/order_status.dart';
import 'package:fruitstime/features/order/domain/entity/order_entity.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/lib.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;

  const OrderCard({super.key, required this.order});

  String _statusLabel(AppLocalizations l) => switch (order.status) {
    OrderStatus.created => l.orderStatusCreated,
    OrderStatus.ready => l.orderStatusReady,
    OrderStatus.done => l.orderStatusDone,
    OrderStatus.canceled => l.orderStatusCanceled,
  };

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    final (statusBg, statusFg, dotColor) = switch (order.status) {
      OrderStatus.ready => (scheme.primary, scheme.onPrimary, scheme.onPrimary),
      OrderStatus.done => (scheme.secondary.withAlpha(30), scheme.secondary, scheme.secondary),
      OrderStatus.canceled => (scheme.error.withAlpha(30), scheme.error, scheme.error),
      OrderStatus.created => (
        scheme.onSurfaceVariant.withAlpha(30),
        scheme.onSurfaceVariant,
        scheme.onSurfaceVariant,
      ),
    };

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.onSurfaceVariant.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Row(
              children: [
                Text(
                  '#${order.number}',
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
            child: Text(
              localization.priceText(formatNumber(order.totalPrice)),
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontSize: 16, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
