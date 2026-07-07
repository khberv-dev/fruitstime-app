import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/banner/domain/entity/banner_entity.dart';
import 'package:fruitstime/features/banner/presentation/ui/stories_screen.dart';
import 'package:fruitstime/features/home/presentation/ui/widget/banner_story_item.dart';

const _itemWidth = 128.0;
const _loopMultiplier = 500;

class BannerStoriesRow extends StatefulWidget {
  final List<BannerEntity> banners;

  const BannerStoriesRow({super.key, required this.banners});

  @override
  State<BannerStoriesRow> createState() => _BannerStoriesRowState();
}

class _BannerStoriesRowState extends State<BannerStoriesRow> {
  final ScrollController _controller = ScrollController();
  Timer? _timer;
  int _index = 0;

  double get _itemExtent => _itemWidth + AppSpacing.md;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void didUpdateWidget(covariant BannerStoriesRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.banners.length != widget.banners.length) {
      _timer?.cancel();
      _index = 0;
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    if (widget.banners.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!_controller.hasClients) return;

      _index++;

      final maxVirtualItems = widget.banners.length * _loopMultiplier;
      if (_index >= maxVirtualItems - widget.banners.length) {
        _index = _index % widget.banners.length;
        _controller.jumpTo(_index * _itemExtent);
      }

      _controller.animateTo(
        _index * _itemExtent,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  void _openStories(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.black,
      builder: (_) => SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.95,
        child: StoriesScreen(banners: widget.banners, initialIndex: index),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 110,
      child: ListView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemExtent: _itemExtent,
        itemCount: widget.banners.length * _loopMultiplier,
        itemBuilder: (_, index) {
          final bannerIndex = index % widget.banners.length;

          return Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: BannerStoryItem(
              banner: widget.banners[bannerIndex],
              onTap: () => _openStories(context, bannerIndex),
            ),
          );
        },
      ),
    );
  }
}
