import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/app/domain/model/nav_item.dart';

class BottomNavbarItem extends StatelessWidget {
  final NavItem item;
  final bool isSelected;

  const BottomNavbarItem({super.key, required this.item, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            item.iconPath,
            width: 24,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(item.text, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: color)),
        ],
      ),
    );
  }
}
