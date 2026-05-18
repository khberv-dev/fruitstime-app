import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/branch/presentation/controller/branches_provider.dart';
import 'package:fruitstime/features/branch/presentation/ui/branch_selector_modal.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class CartBranchSelector extends ConsumerWidget {
  const CartBranchSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final selected = ref.watch(selectedBranchProvider);

    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (_) => const BranchSelectorModal(),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border.all(color: theme.colorScheme.onSurfaceVariant.withAlpha(40)),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Icon(Icons.store_outlined, size: 22, color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.pickUpFrom,
                    style: theme.textTheme.labelSmall!.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selected?.name ?? '—',
                    style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
                  ),
                  if (selected != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      selected.address,
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.unfold_more, size: 20, color: theme.colorScheme.onSurface),
          ],
        ),
      ),
    );
  }
}
