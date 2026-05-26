import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/cart/presentation/controller/fulfillment_provider.dart';
import 'package:fruitstime/features/order/domain/entity/order_address_entity.dart';
import 'package:fruitstime/features/order/presentation/ui/location_picker_screen.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class CartDeliverySelector extends ConsumerWidget {
  const CartDeliverySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final address = ref.watch(fulfillmentProvider).address;

    Future<void> onTap() async {
      final result = await context.push<OrderAddressEntity>(
        LocationPickerScreen.path,
        extra: address,
      );
      if (result != null) {
        ref.read(fulfillmentProvider.notifier).setAddress(result);
      }
    }

    final subtitle = address == null
        ? localization.selectDeliveryAddress
        : address.name ?? '${address.lat.toStringAsFixed(5)}, ${address.long.toStringAsFixed(5)}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border.all(color: theme.colorScheme.onSurfaceVariant.withAlpha(40)),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, size: 22, color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.deliverTo,
                    style: theme.textTheme.labelSmall!.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: theme.colorScheme.onSurface),
          ],
        ),
      ),
    );
  }
}
