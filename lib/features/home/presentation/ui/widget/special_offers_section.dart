import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/core/ui/widget/dot_progress.dart';
import 'package:fruitstime/features/banner/domain/entity/banner_entity.dart';
import 'package:fruitstime/features/home/presentation/ui/widget/banner_carousel_item.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class SpecialOffersSection extends StatefulWidget {
  final List<BannerEntity> banners;

  const SpecialOffersSection({super.key, required this.banners});

  @override
  State<SpecialOffersSection> createState() => _SpecialOffersSectionState();
}

class _SpecialOffersSectionState extends State<SpecialOffersSection> {
  int bannerCarouselIndex = 0;
  final bannerCarouselController = PageController();

  @override
  void initState() {
    super.initState();

    bannerCarouselController.addListener(() {
      setState(() {
        bannerCarouselIndex = bannerCarouselController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.specialOffersTitle,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w900),
        ),
        SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: bannerCarouselController,
            itemCount: widget.banners.length,
            itemBuilder: (_, index) => BannerCarouselItem(banner: widget.banners[index]),
          ),
        ),
        SizedBox(height: AppSpacing.md),
        Center(
          child: DotProgress(value: bannerCarouselIndex, max: widget.banners.length),
        ),
      ],
    );
  }
}
