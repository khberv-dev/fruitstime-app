import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/cart/presentation/controller/fulfillment_provider.dart';
import 'package:fruitstime/features/order/data/enum/order_type.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class FulfillmentToggle extends ConsumerWidget {
  const FulfillmentToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final type = ref.watch(fulfillmentProvider).type;

    Widget segment(OrderType segmentType, String label, IconData icon) {
      final selected = type == segmentType;
      final fg = selected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant;
      return Expanded(
        child: GestureDetector(
          onTap: () => ref.read(fulfillmentProvider.notifier).setType(segmentType),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: selected ? theme.colorScheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: fg),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  label,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.onSurfaceVariant.withAlpha(40)),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          segment(OrderType.pickup, localization.pickupOption, Icons.storefront_outlined),
          segment(OrderType.delivery, localization.deliveryOption, Icons.delivery_dining_outlined),
        ],
      ),
    );
  }
}
