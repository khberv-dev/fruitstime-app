import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/core/ui/widget/item_counter.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';
import 'package:fruitstime/features/product/presentation/ui/widget/add_cart_button.dart';
import 'package:fruitstime/utils/lib.dart';

class ProductListItem extends StatelessWidget {
  final ProductEntity product;
  final int countInCart;
  final Function(ProductEntity) onPressed;
  final VoidCallback? onAddCartClick;
  final VoidCallback? onPopCartClick;
  final bool hasNestedCounter;

  const ProductListItem({
    super.key,
    required this.product,
    this.countInCart = 0,
    required this.onPressed,
    this.onAddCartClick,
    this.onPopCartClick,
    this.hasNestedCounter = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(product),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(40)),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.md)),
              child: FadeInImage(
                placeholder: AssetImage('assets/images/placeholder.png'),
                image: NetworkImage(product.imageUrl),
                width: 96,
                height: 104,
                fit: BoxFit.cover,
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
                    "${formatNumber(product.price)} so'm",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            hasNestedCounter
                ? SizedBox(
                    width: 96,
                    child: countInCart == 0
                        ? AddCartButton(onPressed: onAddCartClick ?? () {})
                        : ItemCounter(
                            value: countInCart,
                            onIncrementClick: onAddCartClick ?? () {},
                            onDecrementClick: onPopCartClick ?? () {},
                          ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
