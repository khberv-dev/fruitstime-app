import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/cart/presentation/controller/payment_type_provider.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class PaymentTypeSelector extends ConsumerWidget {
  const PaymentTypeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final selected = ref.watch(paymentTypeProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.paymentTypeLabel,
          style: theme.textTheme.labelSmall!.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            _Option(
              label: localization.paymentTypeCash,
              icon: Icons.money,
              selected: selected == PaymentType.cash,
              onTap: () => ref.read(paymentTypeProvider.notifier).select(PaymentType.cash),
            ),
            const SizedBox(width: AppSpacing.sm),
            _Option(
              label: localization.paymentTypeCard,
              icon: Icons.credit_card,
              selected: selected == PaymentType.card,
              enabled: false,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _Option extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const _Option({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = enabled
        ? (selected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant)
        : theme.colorScheme.onSurfaceVariant.withAlpha(80);

    return Expanded(
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: selected && enabled
                ? theme.colorScheme.primary.withAlpha(15)
                : theme.colorScheme.surface,
            border: Border.all(
              color: selected && enabled
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant.withAlpha(40),
              width: selected && enabled ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: effectiveColor),
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: effectiveColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
