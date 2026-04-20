import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';

class _Dot extends StatelessWidget {
  final bool isCurrent;

  const _Dot({super.key, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    final color = isCurrent
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface.withAlpha(25);

    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppRadius.round)),
    );
  }
}

class DotProgress extends StatelessWidget {
  final int value;
  final int max;

  const DotProgress({super.key, required this.value, required this.max});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        max,
        (index) => Row(
          children: [
            _Dot(isCurrent: value == index),
            SizedBox(width: AppSpacing.xs),
          ],
        ),
      ),
    );
  }
}
