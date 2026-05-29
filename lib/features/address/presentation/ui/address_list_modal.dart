import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/address/domain/entity/address_entity.dart';
import 'package:fruitstime/features/address/presentation/controller/addresses_provider.dart';
import 'package:fruitstime/features/address/presentation/controller/selected_address_provider.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/user_provider.dart';
import 'package:fruitstime/features/order/domain/entity/order_address_entity.dart';
import 'package:fruitstime/features/order/presentation/ui/location_picker_screen.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/messanger.dart';
import 'package:go_router/go_router.dart';

class AddressListModal extends ConsumerStatefulWidget {
  const AddressListModal({super.key});

  @override
  ConsumerState<AddressListModal> createState() => _AddressListModalState();
}

class _AddressListModalState extends ConsumerState<AddressListModal> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (ref.read(userProvider).data != null) {
        ref.read(addressesProvider.notifier).load();
      }
    });
  }

  Future<void> _onAdd() async {
    final picked = await context.push<OrderAddressEntity>(LocationPickerScreen.path);
    if (picked == null || !mounted) return;

    final name = await _promptName(picked.name ?? '');
    if (name == null || name.trim().isEmpty || !mounted) return;

    await ref
        .read(addressesProvider.notifier)
        .add(name: name.trim(), lat: picked.lat, long: picked.long);
  }

  Future<String?> _promptName(String initial) {
    final localization = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: initial);

    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(localization.addressLabelTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: localization.addressLabelHint),
          onSubmitted: (value) => Navigator.pop(dialogContext, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(localization.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: Text(localization.saveButton),
          ),
        ],
      ),
    );
  }

  Future<void> _onDelete(AddressEntity address) async {
    final localization = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(localization.confirmDialogTitle),
        content: Text(localization.deleteAddressConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(localization.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(localization.deleteButton),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(addressesProvider.notifier).remove(address.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final state = ref.watch(addressesProvider);
    final addresses = state.data ?? [];
    final selected = ref.watch(selectedAddressProvider);

    ref.listen(addressesProvider, (_, next) {
      if (next.error != null) showErrorMessage(context, next.error!);
    });

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withAlpha(60),
                  borderRadius: BorderRadius.circular(AppRadius.round),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              localization.myAddressesTitle,
              style: theme.textTheme.labelSmall!.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (state.isLoading && addresses.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (addresses.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text(
                  localization.noAddresses,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              ...addresses.map(
                (address) => _AddressTile(
                  address: address,
                  isSelected: selected?.id == address.id,
                  onTap: () {
                    ref.read(selectedAddressProvider.notifier).select(address);
                    Navigator.of(context).pop();
                  },
                  onDelete: () => _onDelete(address),
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: _onAdd,
              icon: const Icon(Icons.add_location_alt_outlined, size: 20),
              label: Text(localization.addAddressButton),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressTile extends StatelessWidget {
  final AddressEntity address;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _AddressTile({
    required this.address,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.xs),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md - 2),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 20,
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.name,
                    style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${address.lat.toStringAsFixed(5)}, ${address.long.toStringAsFixed(5)}',
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check, size: 20, color: theme.colorScheme.primary),
            IconButton(
              onPressed: onDelete,
              icon: Icon(Icons.delete_outline, size: 20, color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
