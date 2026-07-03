import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/banner/domain/entity/banner_entity.dart';
import 'package:fruitstime/features/banner/presentation/ui/stories_screen.dart';
import 'package:fruitstime/features/home/presentation/ui/widget/banner_story_item.dart';

class BannerStoriesRow extends StatelessWidget {
  final List<BannerEntity> banners;

  const BannerStoriesRow({super.key, required this.banners});

  void _openStories(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.black,
      builder: (_) => SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.95,
        child: StoriesScreen(banners: banners, initialIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: banners.length,
        separatorBuilder: (_, _) => SizedBox(width: AppSpacing.md),
        itemBuilder: (_, index) =>
            BannerStoryItem(banner: banners[index], onTap: () => _openStories(context, index)),
      ),
    );
  }
}
