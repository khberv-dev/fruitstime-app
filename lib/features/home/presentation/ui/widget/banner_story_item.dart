import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/banner/domain/entity/banner_entity.dart';

class BannerStoryItem extends StatelessWidget {
  final BannerEntity banner;
  final VoidCallback onTap;

  const BannerStoryItem({super.key, required this.banner, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [scheme.primary, scheme.secondary],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(color: scheme.surface, shape: BoxShape.circle),
                child: ClipOval(
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/images/placeholder.png'),
                    image: NetworkImage(banner.thumbnailUrl ?? banner.imageUrl),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              banner.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
