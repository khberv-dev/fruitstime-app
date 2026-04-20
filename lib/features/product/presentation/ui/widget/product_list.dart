import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';
import 'package:fruitstime/features/product/presentation/ui/widget/product_list_item.dart';

class ProductList extends StatelessWidget {
  final List<ProductEntity> products;
  final Map<ProductEntity, int> cartData;
  final Function(ProductEntity) onItemClick;
  final Function(ProductEntity) onAddCartClick;
  final Function(ProductEntity) onPopCartClick;

  const ProductList({
    super.key,
    required this.products,
    required this.cartData,
    required this.onItemClick,
    required this.onAddCartClick,
    required this.onPopCartClick,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(bottom: 128),
      itemBuilder: (_, index) => ProductListItem(
        product: products[index],
        countInCart: cartData[products[index]] ?? 0,
        onPressed: onItemClick,
        onAddCartClick: () => onAddCartClick(products[index]),
        onPopCartClick: () => onPopCartClick(products[index]),
      ),
      separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
      itemCount: products.length,
    );
  }
}
