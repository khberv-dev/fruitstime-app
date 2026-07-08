import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/core/ui/widget/item_counter.dart';
import 'package:fruitstime/features/product/data/enum/product_type.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';
import 'package:fruitstime/features/product/presentation/ui/widget/add_cart_button.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/lib.dart';

class _ProductBadge extends StatelessWidget {
  final Color color;
  final String iconPath;

  const _ProductBadge({super.key, required this.color, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(topRight: Radius.circular(AppRadius.sm)),
      ),
      child: SvgPicture.asset(
        iconPath,
        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }
}

class _PromoRibbon extends StatelessWidget {
  final String text;

  const _PromoRibbon({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: -26,
      bottom: 14,
      child: Transform.rotate(
        angle: -pi / 4,
        child: Container(
          width: 90,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 3),
          color: Theme.of(context).colorScheme.secondary,
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.labelSmall!.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }
}

class ProductListItem extends StatelessWidget {
  final ProductEntity product;
  final int countInCart;
  final Function(ProductEntity) onPressed;
  final VoidCallback? onAddCartClick;
  final VoidCallback? onPopCartClick;
  final bool hasNestedCounter;
  final bool isAvailable;
  final String? availableAt;

  const ProductListItem({
    super.key,
    required this.product,
    this.countInCart = 0,
    required this.onPressed,
    this.onAddCartClick,
    this.onPopCartClick,
    this.hasNestedCounter = true,
    this.isAvailable = true,
    this.availableAt,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    const grayscale = ColorFilter.matrix(<double>[
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]);

    Widget content = Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(40)),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                Container(
                  width: 96,
                  height: 104,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.md)),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: FadeInImage(
                          placeholder: AssetImage('assets/images/placeholder.png'),
                          image: NetworkImage(product.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (product.type == ProductType.vitamin)
                        Positioned(
                          bottom: 0,
                          child: _ProductBadge(
                            color: Theme.of(context).colorScheme.primary,
                            iconPath: 'assets/icons/pill.svg',
                          ),
                        ),
                      if (isAvailable && product.hasBuyTwoGetOneFreePromotion)
                        const _PromoRibbon(text: '2+1'),
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        product.compound.sublist(0, min(2, product.compound.length)).join('•'),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        localization.priceText(formatNumber(product.price)),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasNestedCounter && isAvailable)
                  SizedBox(
                    width: 96,
                    child: countInCart == 0
                        ? AddCartButton(onPressed: onAddCartClick ?? () {})
                        : ItemCounter(
                            value: countInCart,
                            onIncrementClick: onAddCartClick ?? () {},
                            onDecrementClick: onPopCartClick ?? () {},
                          ),
                  ),
              ],
            ),
          ),
          if (!isAvailable && availableAt != null)
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.error,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                localization.availableAtBranch(availableAt!),
                style: Theme.of(
                  context,
                ).textTheme.labelSmall!.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
    );

    if (!isAvailable) {
      content = ColorFiltered(colorFilter: grayscale, child: content);
    }

    return GestureDetector(onTap: isAvailable ? () => onPressed(product) : null, child: content);
  }
}
