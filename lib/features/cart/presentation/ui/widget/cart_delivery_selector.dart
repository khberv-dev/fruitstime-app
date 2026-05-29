import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/address/presentation/controller/addresses_provider.dart';
import 'package:fruitstime/features/address/presentation/controller/selected_address_provider.dart';
import 'package:fruitstime/features/address/presentation/ui/address_list_modal.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/user_provider.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class CartDeliverySelector extends ConsumerStatefulWidget {
  const CartDeliverySelector({super.key});

  @override
  ConsumerState<CartDeliverySelector> createState() => _CartDeliverySelectorState();
}

class _CartDeliverySelectorState extends ConsumerState<CartDeliverySelector> {
  @override
  void initState() {
    super.initState();
    // Load so a previously saved default address resolves and shows here.
    // Addresses require auth, so skip for guests (they log in at checkout).
    Future.microtask(() {
      if (ref.read(userProvider).data != null) {
        ref.read(addressesProvider.notifier).load();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final selected = ref.watch(selectedAddressProvider);

    final subtitle = selected?.name ?? localization.selectDeliveryAddress;

    return GestureDetector(
      onTap: () => showModalBottomSheet(context: context, builder: (_) => const AddressListModal()),
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
