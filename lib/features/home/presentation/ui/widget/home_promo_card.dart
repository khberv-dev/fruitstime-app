import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';

class HomePromoCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color backgroundColor;
  final Color foregroundColor;
  final Alignment textAlignment;
  final VoidCallback onTap;

  const HomePromoCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.backgroundColor,
    required this.foregroundColor,
    this.textAlignment = Alignment.centerLeft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final imageSize = constraints.maxHeight * 1.1;

            return Stack(
              children: [
                Positioned(
                  top: (constraints.maxHeight - imageSize) / 2,
                  right: -imageSize * 0.4,
                  child: SvgPicture.asset(imagePath, width: imageSize, height: imageSize),
                ),
                Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Align(
                    alignment: textAlignment,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.55),
                      child: Text(
                        title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: foregroundColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
