import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/branch/domain/entity/branch_entity.dart';
import 'package:fruitstime/features/branch/presentation/controller/branches_provider.dart';

class BranchSelectorModal extends ConsumerWidget {
  const BranchSelectorModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branches = ref.watch(branchesProvider).data ?? [];
    final selected = ref.watch(selectedBranchProvider);
    final theme = Theme.of(context);

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
              'BRANCHES',
              style: theme.textTheme.labelSmall!.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...branches.map((branch) => _BranchOptionTile(
              branch: branch,
              isSelected: selected?.id == branch.id,
              onTap: () {
                ref.read(selectedBranchProvider.notifier).select(branch);
                Navigator.of(context).pop();
              },
            )),
          ],
        ),
      ),
    );
  }
}

class _BranchOptionTile extends StatelessWidget {
  final BranchEntity branch;
  final bool isSelected;
  final VoidCallback onTap;

  const _BranchOptionTile({
    required this.branch,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.xs),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md - 2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Icon(
              Icons.store_outlined,
              size: 20,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    branch.name,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    branch.address,
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check, size: 20, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
