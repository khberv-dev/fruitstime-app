import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/app/domain/model/nav_item.dart';
import 'package:fruitstime/features/app/presentation/ui/widget/bottom_navbar_item.dart';

class BottomNavbar extends StatelessWidget {
  final TabController controller;
  final List<NavItem> items;
  final double pagerValue;

  const BottomNavbar({
    super.key,
    required this.controller,
    required this.items,
    required this.pagerValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(30)),
      ),
      child: TabBar(
        controller: controller,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
        labelColor: Theme.of(context).colorScheme.onPrimary,
        labelPadding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.tab,
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        tabs: List.generate(
          items.length,
          (index) => BottomNavbarItem(item: items[index], isSelected: pagerValue.round() == index),
        ),
      ),
    );
  }
}
