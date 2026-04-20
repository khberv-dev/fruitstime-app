import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';

class PreferenceItem extends StatelessWidget {
  final String name;
  final String value;
  final String iconPath;
  final VoidCallback? onPressed;
  final Color? itemColor;

  const PreferenceItem({
    super.key,
    required this.name,
    required this.value,
    required this.iconPath,
    this.onPressed,
    this.itemColor,
  });

  @override
  Widget build(BuildContext context) {
    final alpha = itemColor != null ? 255 : 150;
    final color = itemColor ?? Theme.of(context).colorScheme.onSurface;

    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    iconPath,
                    colorFilter: ColorFilter.mode(color.withAlpha(alpha), BlendMode.srcIn),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(color: color.withAlpha(alpha)),
                      ),
                      Text(
                        value,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(color: color, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ],
              ),
              onPressed != null
                  ? SvgPicture.asset(
                      'assets/icons/gt.svg',
                      width: 12,
                      colorFilter: ColorFilter.mode(color.withAlpha(alpha), BlendMode.srcIn),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
