import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';

class _CounterButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _CounterButton({
    super.key,
    required this.text,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isPrimary
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.surface;

    final textColor = isPrimary
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurface;

    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(40)),
            borderRadius: BorderRadius.circular(AppRadius.round),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class ItemCounter extends StatelessWidget {
  final int value;
  final VoidCallback onIncrementClick;
  final VoidCallback onDecrementClick;

  const ItemCounter({
    super.key,
    required this.value,
    required this.onIncrementClick,
    required this.onDecrementClick,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CounterButton(text: '-', isPrimary: false, onPressed: onDecrementClick),
        SizedBox(width: AppSpacing.sm),
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w900),
        ),
        SizedBox(width: AppSpacing.sm),
        _CounterButton(text: '+', isPrimary: true, onPressed: onIncrementClick),
      ],
    );
  }
}
