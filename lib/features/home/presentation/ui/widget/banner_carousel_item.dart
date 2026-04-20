import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/banner/domain/entity/banner_entity.dart';

class BannerCarouselItem extends StatelessWidget {
  final BannerEntity banner;

  const BannerCarouselItem({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.md)),
        child: FadeInImage(
          placeholder: AssetImage('assets/images/placeholder.png'),
          image: NetworkImage(banner.imageUrl),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
