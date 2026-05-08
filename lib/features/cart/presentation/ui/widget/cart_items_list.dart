import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';
import 'package:fruitstime/features/product/presentation/ui/widget/product_list_item.dart';

class CartItemsList extends StatelessWidget {
  final Map<ProductEntity, int> cartData;
  final Function(ProductEntity) onAddCartClick;
  final Function(ProductEntity) onPopCartClick;

  const CartItemsList({
    super.key,
    required this.cartData,
    required this.onAddCartClick,
    required this.onPopCartClick,
  });

  @override
  Widget build(BuildContext context) {
    void onProductItemClick(ProductEntity product) {}

    return Column(
      children: List.generate(
        cartData.keys.length,
        (index) => Column(
          children: [
            ProductListItem(
              product: cartData.keys.elementAt(index),
              countInCart: cartData[cartData.keys.elementAt(index)] ?? 0,
              onPressed: onProductItemClick,
              onAddCartClick: () => onAddCartClick(cartData.keys.elementAt(index)),
              onPopCartClick: () => onPopCartClick(cartData.keys.elementAt(index)),
            ),
            SizedBox(height: AppSpacing.sm),
          ],
        ),
      ).toList(),
    );
  }
}
