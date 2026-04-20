import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';

class PreferencesGroup extends StatelessWidget {
  final String text;
  final Widget child;

  const PreferencesGroup({super.key, required this.text, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(40)),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w900),
            ),
          ),
          Divider(height: 0),
          child,
        ],
      ),
    );
  }
}
